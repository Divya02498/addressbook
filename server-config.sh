sudo yum install git -y
sudo yum install java -y
sudo yum install maven -у
# sudo yum install docker -y
# sudo systemctl start docker

if [ -d "addressbook"]
then
echo "repo is cloned and exists"
cd /home/ec2-user/addressbook
git pull origin master
else
git clone https://github.com/Divya02498/addressbook.git
cd addressbook
git checkout master
fi

#sudo docker build -t $1:$2 /home/ec2-user/addressbook
mvn package
