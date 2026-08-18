############################################
#  subnet/tests/map_public_ip_on_launch.tftest.hcl  #
############################################

# Plan-only tests: no AWS credentials and no API calls are needed.
# Run with `terraform init && terraform test`.

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

variables {
  name               = "test-subnet"
  vpc_id             = "vpc-0123456789abcdef0"
  availability_zones = ["us-east-1a"]
}

run "public_subnet_uses_the_caller_supplied_override" {
  command = plan

  variables {
    public_route_table_ids = ["rtb-0123456789abcdef0"]
    public_subnets = [
      {
        network          = "10.0"
        cidr_blocks      = ["0.0/24"]
        ipv6_network     = "2600:1f18:0000:"
        ipv6_cidr_blocks = ["81::/64"]

        map_public_ip_on_launch = false
      }
    ]
  }

  assert {
    condition     = aws_subnet.public_subnet["us-east-1a-10.0.0.0/24"].map_public_ip_on_launch == false
    error_message = "public subnet ignored map_public_ip_on_launch = false and auto-assigned a public IP"
  }
}

run "public_subnet_still_defaults_to_true" {
  command = plan

  variables {
    public_route_table_ids = ["rtb-0123456789abcdef0"]
    public_subnets = [
      {
        network          = "10.0"
        cidr_blocks      = ["0.0/24"]
        ipv6_network     = "2600:1f18:0000:"
        ipv6_cidr_blocks = ["81::/64"]
      }
    ]
  }

  assert {
    condition     = aws_subnet.public_subnet["us-east-1a-10.0.0.0/24"].map_public_ip_on_launch == true
    error_message = "public subnet no longer defaults to map_public_ip_on_launch = true"
  }
}

run "private_subnet_uses_the_caller_supplied_override" {
  command = plan

  variables {
    private_route_table_ids = ["rtb-0123456789abcdef0"]
    private_subnets = [
      {
        network          = "10.0"
        cidr_blocks      = ["106.0/24"]
        ipv6_network     = "2600:1f18:0000:"
        ipv6_cidr_blocks = ["91::/64"]

        map_public_ip_on_launch = true
      }
    ]
  }

  assert {
    condition     = aws_subnet.private_subnet["us-east-1a-10.0.106.0/24"].map_public_ip_on_launch == true
    error_message = "private subnet ignored map_public_ip_on_launch = true"
  }
}

run "private_subnet_still_defaults_to_false" {
  command = plan

  variables {
    private_route_table_ids = ["rtb-0123456789abcdef0"]
    private_subnets = [
      {
        network          = "10.0"
        cidr_blocks      = ["106.0/24"]
        ipv6_network     = "2600:1f18:0000:"
        ipv6_cidr_blocks = ["91::/64"]
      }
    ]
  }

  assert {
    condition     = aws_subnet.private_subnet["us-east-1a-10.0.106.0/24"].map_public_ip_on_launch == false
    error_message = "private subnet no longer defaults to map_public_ip_on_launch = false"
  }
}
