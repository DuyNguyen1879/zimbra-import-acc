#!/bin/sh

#Hapus Layar
clear

echo -e '###################################################################################'
echo -e '# Zimbra  import-zcs-acc.sh ver 0.0.1                                             #'
echo -e '# Purpose import data account Zimbra                                              #'
echo -e '# Author  'Vavai' Sugianto - vavai@vavai.com                                      #'
echo -e '# Compatibility Centos7 LTS, Zimbra 8.7.x                                         #'
echo -e '# Modifycation Vu Van Than - Linux System Engeneer Updated 05-01-2019             #'
echo -e '###################################################################################'

# /* Variable untuk bold */
ibold="\033[1m""\n===> "
ebold="\033[0m"


if [ "$USER" != "zimbra" ]
then
        echo -e $ibold"You need to be user zimbra to run this script..."$ebold
        exit
fi

CURRENT_FOLDER=`pwd`;

echo ""
echo -e "Please verify that you have copied zcs-acc-add.zmp & zcs-acc-mod.ldif on current folder !"
echo -e "Current Folder : $CURRENT_FOLDER, Please change to your folder before running this script."
echo -e "Press ENTER to continue..."
read jawab

if [ -f ./zcs-acc-add.zmp ];
then
   if [ -f ./zcs-acc-add.zmp ];
        then
                echo -e $ibold"Importing account..."$ebold

                ZIMBRA_LDAP_PASSWORD=`zmlocalconfig -s zimbra_ldap_password | cut -d ' ' -f3`
                ZIMBRA_LDAP_MASTER_URL=`zmlocalconfig -s ldap_master_url | cut -d ' ' -f3`

#               cat ./zcs-acc-add.zmp | su - zimbra -c zmprov
                zmprov < $CURRENT_FOLDER/zcs-acc-add.zmp

                echo -e $ibold"Modify password..."$ebold

                
                ldapmodify -f "$CURRENT_FOLDER/zcs-acc-mod.ldif" -x -H $ZIMBRA_LDAP_MASTER_URL -D cn=config -w $ZIMBRA_LDAP_PASWORD                
#               su - zimbra -c '$LDAP_CMD'

                echo -e $ibold"Zimbra account has been modified sucessfully ..."$ebold

        else
                echo "Sorry, file $CURRENT_FOLDER/zcs-acc-mod.ldif does not exists, import process will not be continue..."
                exit
        fi
else
   echo "Sorry, file $CURRENT_FOLDER/zcs-acc-add.zmp does not exists, import process will not be continue..."
   exit
fi
