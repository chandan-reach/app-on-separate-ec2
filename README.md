# Part 2: Deploy Flask Backend and Express Frontend on Separate AWS EC2 Instances Using Terraform

## Project Overview

The objective of this task is to deploy a full-stack application on AWS using Terraform, where the Flask backend and Express.js frontend run on two separate EC2 instances.

Both application folders are maintained in a single GitHub repository. Each EC2 instance downloads only its required folder using Git Sparse Checkout.

## Architecture

```text
                  User / Browser
                        |
                        |
                 Frontend Public IP
                        |
                        v
              +--------------------+
              |   Frontend EC2      |
              |                    |
              |   Express.js       |
              |   Port: 3000       |
              +--------------------+
                        |
                        | HTTP Request
                        | Backend Private IP:8000
                        v
              +--------------------+
              |    Backend EC2     |
              |                    |
              |    Flask API       |
              |    Port: 8000      |
              +--------------------+
```

## Technologies Used

- AWS EC2
- Terraform
- AWS Security Groups
- Ubuntu Linux
- Python
- Flask
- Node.js
- Express.js
- Git and Git Sparse Checkout

## Project Structure

```text
part-2-separate-ec2/
│
├── main.tf
├── variables.tf
├── outputs.tf
│
└── user-data/
    ├── backend.sh
    └── frontend.sh
```

## GitHub Repository

Repository: https://github.com/chandan-reach/app-for-terraform

The repository contains both application folders:

```text
app-for-terraform/
│
├── backend/
│   ├── app.py
│   └── requirements.txt
│
└── frontend/
    ├── app.js
    ├── package.json
    └── views/
```

## Deployment Steps

### 1. Configure AWS Credentials

Configure AWS CLI before running Terraform:

```bash
aws configure
```

### 2. Initialize Terraform

Navigate to the Part 2 Terraform directory:

```bash
terraform init
```

### 3. Validate Configuration

```bash
terraform validate
```

### 4. Review Execution Plan

```bash
terraform plan
```

### 5. Create EC2 Instances

```bash
terraform apply
```

Type `yes` to confirm.

Terraform creates two EC2 instances:

- Flask Backend EC2
- Express Frontend EC2

### 6. Backend EC2 Setup

Connect to the backend instance:

```bash
ssh -i ~/mykey.pem ubuntu@BACKEND_PUBLIC_IP
```

Clone only the backend folder from the repository:

```bash
git clone --depth 1 --filter=blob:none --sparse https://github.com/chandan-reach/app-for-terraform.git

cd app-for-terraform

git sparse-checkout set backend

cd backend
```

Install Python dependencies:

```bash
source /opt/flask-venv/bin/activate

pip install -r requirements.txt
```

Run the Flask application:

```bash
python app.py
```

Flask runs on port `8000`.

### 7. Frontend EC2 Setup

Connect to the frontend instance:

```bash
ssh -i ~/mykey.pem ubuntu@FRONTEND_PUBLIC_IP
```

Clone only the frontend folder:

```bash
git clone --depth 1 --filter=blob:none --sparse https://github.com/chandan-reach/app-for-terraform.git

cd app-for-terraform

git sparse-checkout set frontend

cd frontend
```

Install Node.js dependencies:

```bash
npm install
```

Run the Express application:

```bash
node app.js
```

Express runs on port `3000`.

## Backend URL Configuration

Since the frontend and backend run on separate EC2 instances, the frontend must communicate with Flask using the backend EC2's private IP address.

In `frontend/app.js`, configure the backend API URL:

```javascript
http://BACKEND_PRIVATE_IP:8000/process
```

Replace `BACKEND_PRIVATE_IP` with the actual private IPv4 address of the backend EC2 instance.

In the Flask application, ensure it listens on all network interfaces:

```python
app.run(host="0.0.0.0", port=8000)
```

Similarly, Express should listen on:

```javascript
app.listen(3000, "0.0.0.0");
```

## Security Group Configuration

| EC2 Instance | Port | Source | Purpose |
|---|---:|---|---|
| Frontend | 22 | My IP | SSH access |
| Frontend | 3000 | 0.0.0.0/0 | Public frontend access |
| Backend | 22 | My IP | SSH access |
| Backend | 8000 | Frontend Security Group | Backend API access |

**Security Note:** Port 8000 should not be publicly accessible. Only the frontend EC2 Security Group should be allowed to access the backend API.

## Application Access

Open the frontend in your browser:

```text
http://FRONTEND_PUBLIC_IP:3000
```

The frontend communicates with the Flask backend through its private IP address.

## Destroy AWS Resources

After completing the task, remove the infrastructure to avoid unnecessary AWS charges:

```bash
terraform destroy
```

Type `yes` to confirm.

## Key Learnings

- Created multiple EC2 instances using Terraform.
- Understood how to deploy frontend and backend separately.
- Learned Git Sparse Checkout to download specific folders from one repository.
- Configured AWS Security Groups for communication between EC2 instances.
- Understood the difference between public IP and private IP.
- Connected an Express.js frontend to a Flask backend using private networking.
- Deployed a full-stack application on AWS without Docker.
