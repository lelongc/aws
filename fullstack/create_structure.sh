#!/bin/bash

# Tạo thư mục fullstack và cấu trúc con
base_dir="$HOME/OneDrive/Máy tính/aws/saa/fullstack"
mkdir -p "$base_dir"
cd "$base_dir" || exit

# 00-Learning_Roadmap
mkdir -p "00-Learning_Roadmap"
touch "00-Learning_Roadmap/01-Beginner_Path.md"
touch "00-Learning_Roadmap/02-Intermediate_Path.md"
touch "00-Learning_Roadmap/03-Advanced_Path.md"
touch "00-Learning_Roadmap/04-Expert_Path.md"

# 01-Programming_Foundations
# Backend Languages
mkdir -p "01-Programming_Foundations/01-Backend_Languages/01-Python/01-Python_Core"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/01-Python/02-Django"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/01-Python/03-Flask"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/01-Python/04-FastAPI"

mkdir -p "01-Programming_Foundations/01-Backend_Languages/02-JavaScript_NodeJS/01-JavaScript_Core"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/02-JavaScript_NodeJS/02-TypeScript"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/02-JavaScript_NodeJS/03-NodeJS_Core"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/02-JavaScript_NodeJS/04-Express"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/02-JavaScript_NodeJS/05-NestJS"

mkdir -p "01-Programming_Foundations/01-Backend_Languages/03-Java/01-Java_Core"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/03-Java/02-Spring_Framework"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/03-Java/03-Spring_Boot"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/03-Java/04-JPA_Hibernate"

mkdir -p "01-Programming_Foundations/01-Backend_Languages/04-CSharp_DotNet/01-CSharp_Core"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/04-CSharp_DotNet/02-DotNet_Core"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/04-CSharp_DotNet/03-ASP_NET"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/04-CSharp_DotNet/04-Entity_Framework"

mkdir -p "01-Programming_Foundations/01-Backend_Languages/05-Other_Languages/01-Go"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/05-Other_Languages/02-Ruby_Rails"
mkdir -p "01-Programming_Foundations/01-Backend_Languages/05-Other_Languages/03-PHP_Laravel"

# Computer Science Fundamentals
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/01-Data_Structures/01-Arrays_Strings"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/01-Data_Structures/02-Linked_Lists"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/01-Data_Structures/03-Stacks_Queues"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/01-Data_Structures/04-Trees_Graphs"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/01-Data_Structures/05-Hash_Tables"

mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/02-Algorithms/01-Sorting"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/02-Algorithms/02-Searching"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/02-Algorithms/03-Dynamic_Programming"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/02-Algorithms/04-Graph_Algorithms"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/02-Algorithms/05-Greedy_Algorithms"

mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/03-Complexity_Analysis/01-Big_O_Notation"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/03-Complexity_Analysis/02-Time_Complexity"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/03-Complexity_Analysis/03-Space_Complexity"

mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/04-Design_Patterns/01-Creational_Patterns"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/04-Design_Patterns/02-Structural_Patterns"
mkdir -p "01-Programming_Foundations/02-Computer_Science_Fundamentals/04-Design_Patterns/03-Behavioral_Patterns"

# Concurrency and Memory
mkdir -p "01-Programming_Foundations/03-Concurrency_And_Memory/01-Concurrency_Models"
mkdir -p "01-Programming_Foundations/03-Concurrency_And_Memory/02-Memory_Management"
mkdir -p "01-Programming_Foundations/03-Concurrency_And_Memory/03-Multithreading"
mkdir -p "01-Programming_Foundations/03-Concurrency_And_Memory/04-Async_Programming"

# 02-Databases
# Database Fundamentals
mkdir -p "02-Databases/01-Database_Fundamentals/01-Database_Design"
mkdir -p "02-Databases/01-Database_Fundamentals/02-Normalization"
mkdir -p "02-Databases/01-Database_Fundamentals/03-ER_Modeling"
mkdir -p "02-Databases/01-Database_Fundamentals/04-CAP_Theorem"

# SQL Databases
mkdir -p "02-Databases/02-SQL_Databases/01-PostgreSQL/01-Installation_Configuration"
mkdir -p "02-Databases/02-SQL_Databases/01-PostgreSQL/02-SQL_Basics_Advanced"
mkdir -p "02-Databases/02-SQL_Databases/01-PostgreSQL/03-Query_Optimization"
mkdir -p "02-Databases/02-SQL_Databases/01-PostgreSQL/04-Administration"

mkdir -p "02-Databases/02-SQL_Databases/02-MySQL/01-Installation_Configuration"
mkdir -p "02-Databases/02-SQL_Databases/02-MySQL/02-SQL_Operations"
mkdir -p "02-Databases/02-SQL_Databases/02-MySQL/03-Performance_Tuning"
mkdir -p "02-Databases/02-SQL_Databases/02-MySQL/04-Replication"

mkdir -p "02-Databases/02-SQL_Databases/03-SQL_Server"
mkdir -p "02-Databases/02-SQL_Databases/04-Oracle"

mkdir -p "02-Databases/02-SQL_Databases/05-Advanced_SQL_Topics/01-Stored_Procedures"
mkdir -p "02-Databases/02-SQL_Databases/05-Advanced_SQL_Topics/02-Triggers"
mkdir -p "02-Databases/02-SQL_Databases/05-Advanced_SQL_Topics/03-Indexing_Strategies"
mkdir -p "02-Databases/02-SQL_Databases/05-Advanced_SQL_Topics/04-Query_Performance"
mkdir -p "02-Databases/02-SQL_Databases/05-Advanced_SQL_Topics/05-Transactions_ACID"
mkdir -p "02-Databases/02-SQL_Databases/05-Advanced_SQL_Topics/06-Replication"
mkdir -p "02-Databases/02-SQL_Databases/05-Advanced_SQL_Topics/07-Sharding"

# NoSQL Databases
mkdir -p "02-Databases/03-NoSQL_Databases/01-Document_Databases/01-MongoDB"
mkdir -p "02-Databases/03-NoSQL_Databases/01-Document_Databases/02-Couchbase"
mkdir -p "02-Databases/03-NoSQL_Databases/02-Key_Value_Stores/01-Redis"
mkdir -p "02-Databases/03-NoSQL_Databases/02-Key_Value_Stores/02-Memcached"
mkdir -p "02-Databases/03-NoSQL_Databases/03-Column_Databases/01-Cassandra"
mkdir -p "02-Databases/03-NoSQL_Databases/04-Graph_Databases/01-Neo4j"

# Caching Strategies
mkdir -p "02-Databases/04-Caching_Strategies/01-Application_Caching"
mkdir -p "02-Databases/04-Caching_Strategies/02-Database_Caching"
mkdir -p "02-Databases/04-Caching_Strategies/03-Distributed_Caching"
mkdir -p "02-Databases/04-Caching_Strategies/04-CDN_Caching"

# 03-API_Development
# API Design Principles
mkdir -p "03-API_Development/01-API_Design_Principles/01-REST_Principles"
mkdir -p "03-API_Development/01-API_Design_Principles/02-API_Versioning"
mkdir -p "03-API_Development/01-API_Design_Principles/03-Status_Codes"
mkdir -p "03-API_Development/01-API_Design_Principles/04-Authentication_Authorization"
mkdir -p "03-API_Development/01-API_Design_Principles/05-Documentation"

# RESTful APIs
mkdir -p "03-API_Development/02-RESTful_APIs/01-REST_Implementation"
mkdir -p "03-API_Development/02-RESTful_APIs/02-Authentication_JWT"
mkdir -p "03-API_Development/02-RESTful_APIs/03-Rate_Limiting"
mkdir -p "03-API_Development/02-RESTful_APIs/04-HATEOAS"

# GraphQL
mkdir -p "03-API_Development/03-GraphQL/01-Schema_Definition"
mkdir -p "03-API_Development/03-GraphQL/02-Queries_Mutations"
mkdir -p "03-API_Development/03-GraphQL/03-Resolvers"
mkdir -p "03-API_Development/03-GraphQL/04-Apollo_Server"

# gRPC
mkdir -p "03-API_Development/04-gRPC/01-Protocol_Buffers"
mkdir -p "03-API_Development/04-gRPC/02-Service_Definition"
mkdir -p "03-API_Development/04-gRPC/03-Streaming"

# WebSockets
mkdir -p "03-API_Development/05-WebSockets/01-WebSocket_Protocol"
mkdir -p "03-API_Development/05-WebSockets/02-Socket_IO"
mkdir -p "03-API_Development/05-WebSockets/03-Real_Time_Apps"

# Message Queues
mkdir -p "03-API_Development/06-Message_Queues/01-RabbitMQ"
mkdir -p "03-API_Development/06-Message_Queues/02-Kafka"
mkdir -p "03-API_Development/06-Message_Queues/03-AWS_SQS_SNS"
mkdir -p "03-API_Development/06-Message_Queues/04-Event_Driven_Patterns"

# 04-Frontend_Development
# Core Web Technologies
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/01-HTML5/01-Semantic_HTML"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/01-HTML5/02-Forms_Validation"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/01-HTML5/03-Accessibility"

mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/02-CSS3/01-Selectors_Properties"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/02-CSS3/02-Flexbox"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/02-CSS3/03-Grid"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/02-CSS3/04-Responsive_Design"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/02-CSS3/05-Animations"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/02-CSS3/06-Sass_Less"

mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/03-JavaScript_TypeScript/01-JavaScript_Core"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/03-JavaScript_TypeScript/02-ES6_Features"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/03-JavaScript_TypeScript/03-TypeScript_Basics"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/03-JavaScript_TypeScript/04-Advanced_TypeScript"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/03-JavaScript_TypeScript/05-DOM_Manipulation"
mkdir -p "04-Frontend_Development/01-Core_Web_Technologies/03-JavaScript_TypeScript/06-Event_Loop"

# Frontend Frameworks
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/01-React/01-React_Core"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/01-React/02-Hooks"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/01-React/03-Context_API"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/01-React/04-Redux"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/01-React/05-React_Router"

mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/02-Next_js/01-Pages_Router"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/02-Next_js/02-App_Router"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/02-Next_js/03-SSR_SSG"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/02-Next_js/04-API_Routes"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/02-Next_js/05-Deployment"

mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/03-Angular/01-Components"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/03-Angular/02-Services"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/03-Angular/03-RxJS"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/03-Angular/04-NgRx"

mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/04-Vue_js/01-Vue_Core"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/04-Vue_js/02-Vue_Router"
mkdir -p "04-Frontend_Development/02-Frontend_Frameworks/04-Vue_js/03-Vuex"

# Build Tools
mkdir -p "04-Frontend_Development/03-Build_Tools/01-Webpack"
mkdir -p "04-Frontend_Development/03-Build_Tools/02-Vite"
mkdir -p "04-Frontend_Development/03-Build_Tools/03-Babel"
mkdir -p "04-Frontend_Development/03-Build_Tools/04-ESLint_Prettier"

# Frontend Performance
mkdir -p "04-Frontend_Development/04-Frontend_Performance/01-Code_Splitting"
mkdir -p "04-Frontend_Development/04-Frontend_Performance/02-Lazy_Loading"
mkdir -p "04-Frontend_Development/04-Frontend_Performance/03-Image_Optimization"
mkdir -p "04-Frontend_Development/04-Frontend_Performance/04-Rendering_Strategies"
mkdir -p "04-Frontend_Development/04-Frontend_Performance/05-Lighthouse"

# Web APIs
mkdir -p "04-Frontend_Development/05-Web_APIs/01-Fetch_API"
mkdir -p "04-Frontend_Development/05-Web_APIs/02-Storage_APIs"
mkdir -p "04-Frontend_Development/05-Web_APIs/03-Service_Workers"
mkdir -p "04-Frontend_Development/05-Web_APIs/04-Web_Components"

# 05-Software_Architecture
# Architecture Fundamentals
mkdir -p "05-Software_Architecture/01-Architecture_Fundamentals/01-Architecture_Styles"
mkdir -p "05-Software_Architecture/01-Architecture_Fundamentals/02-Component_Design"
mkdir -p "05-Software_Architecture/01-Architecture_Fundamentals/03-System_Quality_Attributes"

# Monolithic
mkdir -p "05-Software_Architecture/02-Monolithic/01-Monolith_Design"
mkdir -p "05-Software_Architecture/02-Monolithic/02-Modular_Monoliths"
mkdir -p "05-Software_Architecture/02-Monolithic/03-Migration_Strategies"

# Microservices
mkdir -p "05-Software_Architecture/03-Microservices/01-Service_Design"
mkdir -p "05-Software_Architecture/03-Microservices/02-Service_Discovery"
mkdir -p "05-Software_Architecture/03-Microservices/03-API_Gateway"
mkdir -p "05-Software_Architecture/03-Microservices/04-Circuit_Breaker"
mkdir -p "05-Software_Architecture/03-Microservices/05-Distributed_Tracing"
mkdir -p "05-Software_Architecture/03-Microservices/06-Data_Consistency"

# Serverless
mkdir -p "05-Software_Architecture/04-Serverless/01-FaaS_Fundamentals"
mkdir -p "05-Software_Architecture/04-Serverless/02-AWS_Lambda"
mkdir -p "05-Software_Architecture/04-Serverless/03-Azure_Functions"
mkdir -p "05-Software_Architecture/04-Serverless/04-Cloud_Functions"
mkdir -p "05-Software_Architecture/04-Serverless/05-Serverless_Patterns"

# Event Driven
mkdir -p "05-Software_Architecture/05-Event_Driven/01-Event_Sourcing"
mkdir -p "05-Software_Architecture/05-Event_Driven/02-CQRS"
mkdir -p "05-Software_Architecture/05-Event_Driven/03-Pub_Sub_Pattern"
mkdir -p "05-Software_Architecture/05-Event_Driven/04-Event_Streaming"

# Domain Driven Design
mkdir -p "05-Software_Architecture/06-Domain_Driven_Design/01-Bounded_Contexts"
mkdir -p "05-Software_Architecture/06-Domain_Driven_Design/02-Aggregates_Entities"
mkdir -p "05-Software_Architecture/06-Domain_Driven_Design/03-Value_Objects"
mkdir -p "05-Software_Architecture/06-Domain_Driven_Design/04-Domain_Events"
mkdir -p "05-Software_Architecture/06-Domain_Driven_Design/05-Strategic_Design"

# 06-DevOps_CI_CD
# Version Control
mkdir -p "06-DevOps_CI_CD/01-Version_Control/01-Git_Basics"
mkdir -p "06-DevOps_CI_CD/01-Version_Control/02-Advanced_Git"
mkdir -p "06-DevOps_CI_CD/01-Version_Control/03-Branching_Strategies"
mkdir -p "06-DevOps_CI_CD/01-Version_Control/04-Monorepo_Management"

# CI/CD Pipelines
mkdir -p "06-DevOps_CI_CD/02-CI_CD_Pipelines/01-Jenkins"
mkdir -p "06-DevOps_CI_CD/02-CI_CD_Pipelines/02-GitHub_Actions"
mkdir -p "06-DevOps_CI_CD/02-CI_CD_Pipelines/03-GitLab_CI"
mkdir -p "06-DevOps_CI_CD/02-CI_CD_Pipelines/04-CircleCI"
mkdir -p "06-DevOps_CI_CD/02-CI_CD_Pipelines/05-Pipeline_Design/01-Build"
mkdir -p "06-DevOps_CI_CD/02-CI_CD_Pipelines/05-Pipeline_Design/02-Test"
mkdir -p "06-DevOps_CI_CD/02-CI_CD_Pipelines/05-Pipeline_Design/03-Security_Scan"
mkdir -p "06-DevOps_CI_CD/02-CI_CD_Pipelines/05-Pipeline_Design/04-Deployment_Strategies"

# Containerization
mkdir -p "06-DevOps_CI_CD/03-Containerization/01-Docker_Basics"
mkdir -p "06-DevOps_CI_CD/03-Containerization/02-Dockerfile_Best_Practices"
mkdir -p "06-DevOps_CI_CD/03-Containerization/03-Multi_Stage_Builds"
mkdir -p "06-DevOps_CI_CD/03-Containerization/04-Container_Security"
mkdir -p "06-DevOps_CI_CD/03-Containerization/05-Docker_Compose"

# Orchestration
mkdir -p "06-DevOps_CI_CD/04-Orchestration/01-Kubernetes_Basics/01-Architecture"
mkdir -p "06-DevOps_CI_CD/04-Orchestration/01-Kubernetes_Basics/02-Pods_Services"
mkdir -p "06-DevOps_CI_CD/04-Orchestration/01-Kubernetes_Basics/03-Deployments"

mkdir -p "06-DevOps_CI_CD/04-Orchestration/02-Kubernetes_Advanced/01-StatefulSets"
mkdir -p "06-DevOps_CI_CD/04-Orchestration/02-Kubernetes_Advanced/02-DaemonSets"
mkdir -p "06-DevOps_CI_CD/04-Orchestration/02-Kubernetes_Advanced/03-ConfigMaps_Secrets"
mkdir -p "06-DevOps_CI_CD/04-Orchestration/02-Kubernetes_Advanced/04-RBAC"
mkdir -p "06-DevOps_CI_CD/04-Orchestration/02-Kubernetes_Advanced/05-Custom_Resources"

mkdir -p "06-DevOps_CI_CD/04-Orchestration/03-Kubernetes_Networking/01-Service_Types"
mkdir -p "06-DevOps_CI_CD/04-Orchestration/03-Kubernetes_Networking/02-Ingress"
mkdir -p "06-DevOps_CI_CD/04-Orchestration/03-Kubernetes_Networking/03-Network_Policies"
mkdir -p "06-DevOps_CI_CD/04-Orchestration/03-Kubernetes_Networking/04-Service_Mesh"

mkdir -p "06-DevOps_CI_CD/04-Orchestration/04-Helm/01-Charts"
mkdir -p "06-DevOps_CI_CD/04-Orchestration/04-Helm/02-Templates"
mkdir -p "06-DevOps_CI_CD/04-Orchestration/04-Helm/03-Releases"

# IaC (Infrastructure as Code)
mkdir -p "06-DevOps_CI_CD/05-IaC/01-Terraform/01-HCL_Basics"
mkdir -p "06-DevOps_CI_CD/05-IaC/01-Terraform/02-Providers"
mkdir -p "06-DevOps_CI_CD/05-IaC/01-Terraform/03-Modules"
mkdir -p "06-DevOps_CI_CD/05-IaC/01-Terraform/04-State_Management"

mkdir -p "06-DevOps_CI_CD/05-IaC/02-CloudFormation"
mkdir -p "06-DevOps_CI_CD/05-IaC/03-ARM_Templates"
mkdir -p "06-DevOps_CI_CD/05-IaC/04-Configuration_Management/01-Ansible"
mkdir -p "06-DevOps_CI_CD/05-IaC/04-Configuration_Management/02-Chef"
mkdir -p "06-DevOps_CI_CD/05-IaC/04-Configuration_Management/03-Puppet"

# Monitoring & Logging
mkdir -p "06-DevOps_CI_CD/06-Monitoring_Logging/01-Metrics/01-Prometheus"
mkdir -p "06-DevOps_CI_CD/06-Monitoring_Logging/01-Metrics/02-Grafana"
mkdir -p "06-DevOps_CI_CD/06-Monitoring_Logging/02-Logging/01-ELK_Stack"
mkdir -p "06-DevOps_CI_CD/06-Monitoring_Logging/02-Logging/02-EFK_Stack"
mkdir -p "06-DevOps_CI_CD/06-Monitoring_Logging/02-Logging/03-Loki"
mkdir -p "06-DevOps_CI_CD/06-Monitoring_Logging/03-Tracing/01-Jaeger"
mkdir -p "06-DevOps_CI_CD/06-Monitoring_Logging/03-Tracing/02-Zipkin"
mkdir -p "06-DevOps_CI_CD/06-Monitoring_Logging/04-Alerting/01-Alertmanager"
mkdir -p "06-DevOps_CI_CD/06-Monitoring_Logging/04-Alerting/02-PagerDuty"

# 07-Cloud_Computing
# Cloud Fundamentals
mkdir -p "07-Cloud_Computing/01-Cloud_Fundamentals/01-Cloud_Models"
mkdir -p "07-Cloud_Computing/01-Cloud_Fundamentals/02-Global_Infrastructure"
mkdir -p "07-Cloud_Computing/01-Cloud_Fundamentals/03-Shared_Responsibility"

# AWS
mkdir -p "07-Cloud_Computing/02-AWS/01-Compute/01-EC2"
mkdir -p "07-Cloud_Computing/02-AWS/01-Compute/02-Lambda"
mkdir -p "07-Cloud_Computing/02-AWS/01-Compute/03-ECS"
mkdir -p "07-Cloud_Computing/02-AWS/01-Compute/04-EKS"
mkdir -p "07-Cloud_Computing/02-AWS/02-Storage/01-S3"
mkdir -p "07-Cloud_Computing/02-AWS/02-Storage/02-EBS"
mkdir -p "07-Cloud_Computing/02-AWS/02-Storage/03-EFS"
mkdir -p "07-Cloud_Computing/02-AWS/02-Storage/04-Glacier"
mkdir -p "07-Cloud_Computing/02-AWS/03-Databases/01-RDS"
mkdir -p "07-Cloud_Computing/02-AWS/03-Databases/02-DynamoDB"
mkdir -p "07-Cloud_Computing/02-AWS/03-Databases/03-ElastiCache"
mkdir -p "07-Cloud_Computing/02-AWS/04-Networking/01-VPC"
mkdir -p "07-Cloud_Computing/02-AWS/04-Networking/02-Load_Balancers"
mkdir -p "07-Cloud_Computing/02-AWS/04-Networking/03-Route53"
mkdir -p "07-Cloud_Computing/02-AWS/04-Networking/04-CloudFront"
mkdir -p "07-Cloud_Computing/02-AWS/05-IAM"
mkdir -p "07-Cloud_Computing/02-AWS/06-Well_Architected"

# Azure
mkdir -p "07-Cloud_Computing/03-Azure/01-Compute/01-VMs"
mkdir -p "07-Cloud_Computing/03-Azure/01-Compute/02-Functions"
mkdir -p "07-Cloud_Computing/03-Azure/01-Compute/03-AKS"
mkdir -p "07-Cloud_Computing/03-Azure/01-Compute/04-App_Service"
mkdir -p "07-Cloud_Computing/03-Azure/02-Storage"
mkdir -p "07-Cloud_Computing/03-Azure/03-Databases"
mkdir -p "07-Cloud_Computing/03-Azure/04-Networking"

# GCP
mkdir -p "07-Cloud_Computing/04-GCP/01-Compute"
mkdir -p "07-Cloud_Computing/04-GCP/02-Storage"
mkdir -p "07-Cloud_Computing/04-GCP/03-Databases"
mkdir -p "07-Cloud_Computing/04-GCP/04-Networking"

# Cloud Native
mkdir -p "07-Cloud_Computing/05-Cloud_Native/01-12Factor_Apps"
mkdir -p "07-Cloud_Computing/05-Cloud_Native/02-Microservices_Cloud"
mkdir -p "07-Cloud_Computing/05-Cloud_Native/03-Serverless_Architecture"
mkdir -p "07-Cloud_Computing/05-Cloud_Native/04-Multi_Cloud_Strategy"

# 08-Security
# Web Security
mkdir -p "08-Security/01-Web_Security/01-OWASP_Top_10"
mkdir -p "08-Security/01-Web_Security/02-XSS"
mkdir -p "08-Security/01-Web_Security/03-CSRF"
mkdir -p "08-Security/01-Web_Security/04-SQL_Injection"
mkdir -p "08-Security/01-Web_Security/05-Security_Headers"

# Authentication
mkdir -p "08-Security/02-Authentication/01-OAuth_2"
mkdir -p "08-Security/02-Authentication/02-OpenID_Connect"
mkdir -p "08-Security/02-Authentication/03-JWT"
mkdir -p "08-Security/02-Authentication/04-SAML"
mkdir -p "08-Security/02-Authentication/05-RBAC"

# Encryption
mkdir -p "08-Security/03-Encryption/01-Encryption_Basics"
mkdir -p "08-Security/03-Encryption/02-TLS_SSL"
mkdir -p "08-Security/03-Encryption/03-Data_At_Rest"
mkdir -p "08-Security/03-Encryption/04-Key_Management"

# Security Best Practices
mkdir -p "08-Security/04-Security_Best_Practices/01-Secrets_Management"
mkdir -p "08-Security/04-Security_Best_Practices/02-Least_Privilege"
mkdir -p "08-Security/04-Security_Best_Practices/03-MFA"
mkdir -p "08-Security/04-Security_Best_Practices/04-Secure_Coding"

# DevSecOps
mkdir -p "08-Security/05-DevSecOps/01-SAST"
mkdir -p "08-Security/05-DevSecOps/02-DAST"
mkdir -p "08-Security/05-DevSecOps/03-Dependency_Scanning"
mkdir -p "08-Security/05-DevSecOps/04-Container_Security"

# 09-Testing
# Unit Testing
mkdir -p "09-Testing/01-Unit_Testing/01-Test_Frameworks"
mkdir -p "09-Testing/01-Unit_Testing/02-Mocking"
mkdir -p "09-Testing/01-Unit_Testing/03-Test_Coverage"

# Integration Testing
mkdir -p "09-Testing/02-Integration_Testing/01-API_Testing"
mkdir -p "09-Testing/02-Integration_Testing/02-Database_Testing"
mkdir -p "09-Testing/02-Integration_Testing/03-Service_Integration"

# End-to-End Testing
mkdir -p "09-Testing/03-End_to_End_Testing/01-Cypress"
mkdir -p "09-Testing/03-End_to_End_Testing/02-Playwright"
mkdir -p "09-Testing/03-End_to_End_Testing/03-Selenium"

# Performance Testing
mkdir -p "09-Testing/04-Performance_Testing/01-JMeter"
mkdir -p "09-Testing/04-Performance_Testing/02-k6"
mkdir -p "09-Testing/04-Performance_Testing/03-Gatling"

# Testing Methodologies
mkdir -p "09-Testing/05-Testing_Methodologies/01-TDD"
mkdir -p "09-Testing/05-Testing_Methodologies/02-BDD"
mkdir -p "09-Testing/05-Testing_Methodologies/03-Test_Pyramids"

# 10-Soft_Skills
# Technical Communication
mkdir -p "10-Soft_Skills/01-Technical_Communication/01-Technical_Writing"
mkdir -p "10-Soft_Skills/01-Technical_Communication/02-Code_Documentation"
mkdir -p "10-Soft_Skills/01-Technical_Communication/03-Presentations"

# Team Collaboration
mkdir -p "10-Soft_Skills/02-Team_Collaboration/01-Code_Reviews"
mkdir -p "10-Soft_Skills/02-Team_Collaboration/02-Pair_Programming"
mkdir -p "10-Soft_Skills/02-Team_Collaboration/03-Mentoring"

# Project Management
mkdir -p "10-Soft_Skills/03-Project_Management/01-Agile_Scrum"
mkdir -p "10-Soft_Skills/03-Project_Management/02-Kanban"
mkdir -p "10-Soft_Skills/03-Project_Management/03-Estimation"

# Career Development
mkdir -p "10-Soft_Skills/04-Career_Development/01-Technical_Leadership"
mkdir -p "10-Soft_Skills/04-Career_Development/02-Interview_Preparation"
mkdir -p "10-Soft_Skills/04-Career_Development/03-Personal_Branding"

# Additional recommended folders
mkdir -p "Projects"
mkdir -p "Resources/Books"
mkdir -p "Resources/Courses"
mkdir -p "Resources/Cheatsheets"
mkdir -p "Certifications/AWS"
mkdir -p "Certifications/Azure"
mkdir -p "Certifications/Kubernetes"
mkdir -p "Certifications/Other"

echo "✅ Cấu trúc thư mục chi tiết đã được tạo thành công!"
