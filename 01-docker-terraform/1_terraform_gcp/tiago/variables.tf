variable "bq_dataset_name" {
    description = "My Bigquery Dataset name"
    default = "demo_dataset"
}

variable "gcs_sotrage_class" {
    description = "Bucket Storage Class"
    default = "STANDARD"
}

variable "location" {
  default = "EU"
}

variable "project" {
    default = "zoomcamp-tiago-411410"
  
}

variable "credentials" {
    default = "/Users/tiagocabaco/.gc/zoomcamp_gc.json"
}