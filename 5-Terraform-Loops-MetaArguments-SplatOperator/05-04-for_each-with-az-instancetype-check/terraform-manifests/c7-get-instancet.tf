data "aws_availability_zones" "my_azones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ec2_instance_type_offerings" "my_ins_type" {            #Chọn instance theo t2.micro và location: AZ của region
  for_each = toset(data.aws_availability_zones.my_azones.names)   #Lấy tên AZ
  filter {
    name   = "instance-type"
    values = ["t2.micro"]
  }
  filter {
    name   = "location"
    values = [each.key]
  }
  location_type = "availability-zone"
}


# Output-1
# Basic Output: All Availability Zones mapped to Supported Instance Types
output "output_v3_1" {
  value = {
  for az, details in data.aws_ec2_instance_type_offerings.my_ins_type: az => details.instance_types
  }
}

# Output-2
# Filtered Output: Exclude Unsupported Availability Zones
output "output_v3_2" {
  value = {
  for az, details in data.aws_ec2_instance_type_offerings.my_ins_type:
  az => details.instance_types if length(details.instance_types) != 0 }
}

# Output-3
# Filtered Output: with Keys Function - Which gets keys from a Map
# This will return the list of availability zones supported for a instance type
output "output_v3_3" {
  value = keys({
  for az, details in data.aws_ec2_instance_type_offerings.my_ins_type:
  az => details.instance_types if length(details.instance_types) != 0 })
}


#Lấy AZ đầu tiên thõa mãn (key(...)[0])
output "output_v3_4" {
  value = keys({
  for az, details in data.aws_ec2_instance_type_offerings.my_ins_type:
  az => details.instance_types if length(details.instance_types) != 0 })[0]
}
