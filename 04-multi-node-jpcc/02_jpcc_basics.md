# JLupin Platform Control Center

JLupin Control Center is a tool for managing whole environment build with JLupin Platform. It allows to scale your environment, change configurations, manage nodes, microservices, applications, etc. It operates on some primary units to make managing your environment easier.

`console.sh`{{execute}}

Login: `user_admin`
Password: `user_admin`

`user_admin@/jlupin/zone/default> user create admin MASTER_ADMIN`
Password your own.

`user_admin@/jlupin/zone/default> login`

Login: `admin`
Password: you typed


[exchange app - deployed on NODE_1](https://[[HOST_SUBDOMAIN]]-13000-[[KATACODA_HOST]].environments.katacoda.com/exchange/)
or
[exchange app - deployed on NODE_2](https://[[HOST_SUBDOMAIN]]-18000-[[KATACODA_HOST]].environments.katacoda.com/exchange/).

[webcontrol app - deployed on NODE_1](https://[[HOST_SUBDOMAIN]]-13888-[[KATACODA_HOST]].environments.katacoda.com/webcontrol/)
or
[webcontrol app - deployed on NODE_2](https://[[HOST_SUBDOMAIN]]-18888-[[KATACODA_HOST]].environments.katacoda.com/webcontrol/).

`console`{{execute}}

`zone list`{{execute}}

`zone create zone_a`{{execute}}

`cd ../zone_a`{{execute}}

`zone list`{{execute}}

`node connect localhost zone_a 14096`{{execute}}

`zone list`{{execute}}

`node connect localhost zone_a 19096`{{execute}}

`zone list`{{execute}}

`node status`{{execute}}

`node peers`{{execute}}

`zone connect zone_a NODE_1 zone_a NODE_2`{{execute}}

`node peers`{{execute}}

`zone connect zone_a NODE_2 zone_a NODE_1`{{execute}}
