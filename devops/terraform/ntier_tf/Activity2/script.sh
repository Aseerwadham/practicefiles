#!/bin/bash
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y apt-transport-https aspnetcore-runtime-7.0
sudo wget https://github.com/nopSolutions/nopCommerce/releases/download/release-4.60.2/nopCommerce_4.60.2_NoSource_linux_x64.zip
mkdir ~/nop
sudo apt-get install unzip
cp nopCommerce_4.60.2_NoSource_linux_x64.zip nop
cd nop
sudo unzip nopCommerce_4.60.2_NoSource_linux_x64.zip
sudo mkdir bin logs
sudo mv nopCommerce.service /tmp
sudo cp /tmp/nopCommerce.service /etc/systemd/system/nopCommerce.service
sudo systemctl start nopCommerce.service
sudo systemctl status nopCommerce.service
# #!/bin/bash

# echo {1..10}

# END=10
# for ((i=1;i<=END;i++));
# do
#   echo $i
# done  


# #!/bin/bash
# a=2
# b=5
# if (($a != $b))
# then echo "true"
# else echo "false"
# fi


# #!/bin/bash
# read -p "what is your name?: "reply
# name=Asee
# user=$reply
# if [ $user -eq $name ]
# then
#  echo "i love you darling"
# else
#  echo "i hate you darling"
# fi    


# #!/bin/bash
# echo {1..50} | wc


# #!/bin/bash
# sudo apt update
# sudo yum update
# distribution=$(get_distribution)
# if (($distribution == "ubuntu"));
# then
#    sudo apt update
# elif(else) 
#    sudo yum update
# fi     


# #!/bin/bash
# index=1
# while [ $index -lt 100 ];
# do 
#   echo $index
#   index=$(($index + 1))
# done  

# ##In vm 
# ##number=90
# ##echo $((number % 2 ))
# ##result=0[which means num is even]
# ##number=9
# ##echo $((number % 2 ))
# ##result=1[which means num is odd]


# #!/bin/bash

# for index in {1..99}
# do
#   remainder=$((index % 2))
#   if [ $remainder -eq 1 ];
#   then
#     echo $index
#   fi
# done    




# -100<=X,Y<=100
# Y!=0
# X+Y, X-Y, X*Y, X/Y
# #!/bin/bash
# read X
# read Y
# if [ $X -le -100 ] && [ $X -ge 100 ] && [ $Y -ne 0 ];
# then
#    echo  $(($X + $Y)) 
#    echo  $(($X - $Y)) 
#    echo  $(($X * $Y)) 
#    echo  $(($X / $Y)) 
# else
#    echo "validations failed"
#    exit 1   
# fi   

# #!/bin/bash
# END=1000
# for ((i=1;i<=END;i++));
# do
#   echo $i
# done  
