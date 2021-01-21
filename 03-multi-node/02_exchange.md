# Example microservice architecture - Exchange

If the scripts in the previous step finished successfully, you should be able to see the application by opening the following link in the new browser tab:
[exchange app - deployed on NODE_1](https://[[HOST_SUBDOMAIN]]-8000-[[KATACODA_HOST]].environments.katacoda.com/exchange/)
or
[exchange app - deployed on NODE_2](https://[[HOST_SUBDOMAIN]]-18000-[[KATACODA_HOST]].environments.katacoda.com/exchange/).

For the purpose of this scenario we prepared both nodes with an example application consisting of several microservices. As you probably already know from the previous scenario, you can view all deployed and running microservices using webcontrol UI or the CLI.

Just a quick reminder:
- to fire up the CLI for NODE_1:
  `/opt/jlupin/platform1/start/control.sh`{{execute}}

- to fire up the CLI for NODE_2:
  `/opt/jlupin/platform2/start/control.sh`{{execute}}

- to see the list of deployed microservices and number of their instances:
  `microservice list`{{execute}}

To see the node details on webcontrol UI, open any of those link in a new tab [webcontrol for NODE_1](https://[[HOST_SUBDOMAIN]]-8888-[[KATACODA_HOST]].environments.katacoda.com/webcontrol/) or [webcontrol for NODE_2](https://[[HOST_SUBDOMAIN]]-18888-[[KATACODA_HOST]].environments.katacoda.com/webcontrol/).

You'll notice that for each node, there's one microservice that is not started, this in purpose. Your task will be not to start it (as we did in the previous scenario) but to enable communication between both nodes thus having complete functionality of the exchange application.
