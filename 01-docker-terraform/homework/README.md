## 01-docker-terraform

In this directory you'll find my code to solve the homework challenges. 

## Docker set up

1 - I used [docker-compose](docker-compose.yaml) to setup the postgres service.

2 - Because the port `5432` was forward to my local environment, I just ran the [ingestion script](ingest_homework_data.py) using the following code:

```python
python ingest_homework_data.py --user=root \
    --password=root \
    --host=localhost \
    --port=5432 \
    --db=ny_taxi \
    --table_name=green_taxi_data \
    --taxi_data_url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz" \
    --zones_url="https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv"

```

3 - I then just connected to the `ny_taxi` database using `pgcli`  and did the necesary
quering. You'll find all queries here: [sql_solutions.sql](sql_solutions.sql).

## Terraform

- As instructed, I updated the variables file ([here](terraform/variables.tf)) and 
planned and applied the terraform instructions with the output: 

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with
the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.demo_dataset will be created
  + resource "google_bigquery_dataset" "demo_dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "demo_dataset_tiago_hw"
      + default_collation          = (known after apply)
      + delete_contents_on_destroy = false
      + effective_labels           = (known after apply)
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + is_case_insensitive        = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "US"
      + max_time_travel_hours      = (known after apply)
      + project                    = "zoomcamp-tiago-411410"
      + self_link                  = (known after apply)
      + storage_billing_model      = (known after apply)
      + terraform_labels           = (known after apply)
    }

  # google_storage_bucket.demo-bucket will be created
  + resource "google_storage_bucket" "demo-bucket" {
      + effective_labels            = (known after apply)
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "US"
      + name                        = "zoomcamp-tiago-411410_gc_bucket_dem"
      + project                     = (known after apply)
      + public_access_prevention    = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = (known after apply)
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "AbortIncompleteMultipartUpload"
            }
          + condition {
              + age                   = 1
              + matches_prefix        = []
              + matches_storage_class = []
              + matches_suffix        = []
              + with_state            = (known after apply)
            }
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.demo_dataset: Creating...
google_storage_bucket.demo-bucket: Creating...
google_bigquery_dataset.demo_dataset: Creation complete after 1s [id=projects/zoomcamp-tiago-411410/datasets/demo_dataset_tiago_hw]
google_storage_bucket.demo-bucket: Creation complete after 3s [id=zoomcamp-tiago-411410_gc_bucket_dem]
```