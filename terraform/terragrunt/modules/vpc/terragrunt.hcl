terraform {
  source = "../../../modules//vpc/"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {

}