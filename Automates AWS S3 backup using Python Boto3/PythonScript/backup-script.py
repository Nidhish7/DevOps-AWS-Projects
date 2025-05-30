import boto3
import os

# Configuration 
s3_bucket = "s3-backup-using-python"
backup_folder = "backup-files/"
local_folder = "C:/Users/hp/Desktop/AWS/"

# Initialize S3 Client
s3 = boto3.client("s3")

def upload_folder_to_s3(local_folder,s3_bucket,backup_folder):
    """Uploads all files from a local folder to S3"""
    try:
        for root, _, files in os.walk(local_folder):
            for file in files:
                local_file_path = os.path.join(root, file)
                s3_key = f"{backup_folder}{file}"   # Store files in s3 under backup-folder/
                
                # Upload file to S3
                s3.upload_file(local_file_path, s3_bucket, s3_key)
                print(f"✅ Uploaded: {local_file_path} → s3://{s3_bucket}/{s3_key}")
    
    except Exception as e:
        print(f"❌ Upload failed: {e}")
        

# run the backup
upload_folder_to_s3(local_folder, s3_bucket, backup_folder)