#Execute below command to get meta data
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/

sau đường dẫn đó có thể lấy thông tin ipv4 của ec2 chẳng hạn balabala 
 http://169.254.169.254/latest/meta-data/public-ipv4