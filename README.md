## Background Information

In order to send and receive data from custom applications, this interface was developed to allow for data transfer without the need of OAuth or storing username and passwords in the application.

This had to be built from scratch so it may not have everything, see the to do section for any upcoming features. Note that this is the bare minimum required for the data transfer and as a best practice it was decided to have Salesforce initiate the data transfer.

Azure integration allows for data to be transformed via JSON format so you will have to make your own batch and schedulable classes so that you can schedule as needed.

## [AzureGenerateToken](https://github.com/rruprai/sfdc-microsoft-azure-service-bus/blob/master/classes/AzureGenerateToken.cls)

This is the most important class since it is the one that generates the SAS Token that is needed for establishing a connection whether or not you are sending or receiving. The [AzureReceiver](https://github.com/rruprai/sfdc-microsoft-azure-service-bus/blob/master/classes/AzureReceiver.cls) class is just a sample of how you can implement the receive (peekQueue) and the "receive and delete" operations.

## Getting Started

* Download the repository and use any CLI tool such as [Ant Migration Tool](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_deploying_ant.htm).
* Based on your application you will need to modify the classes so that you send and receive your data in JSON format.
* After an agreement is in place on what the JSON's structure will be you can modify the AzureJsonBodyWrapper and AzureBody classes as needed.

## Considerations

* Ensure you follow the most up to documentation from Azure starting with [Service Bus authentication and authorization](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-authentication-and-authorization)
* Test classes were added in order to assure code coverage, but you may write your own.
* I purposely did not include a test mock callout because I do not have access to a live instance so assume you will need to create one according to [Salesforce's example](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_testing_httpcalloutmock.htm)
* For companies with multiple sandboxes and a production org, I would recommend using [forcedevtool](https://github.com/amtrack/force-dev-tool) to help manage differences between versions. This is an awesome tool that will make continuous integration easy.
* There are more than one ways to format the JSON so you will be able to modify as needed. I left a couple default in there such as receiverId and senderId.

## Azure Config object

This is used to store any customer settings such as keyName, QueueName, endpoint, and many more details. This will allow for easily modifying the connection settings regardless of what environment you are using. Main purpose to store the keys using Encrypted fields and can be enhanced. 

## Azure Message Object

Main purpose of this object is to store information regarding the data transfer (send or receive). This is an optional object, but for those who do not log on the Azure side, we can at least log on the Salesforce side. You may want to put some rules on what you save and for how long you keep them in your Salesforce org before deleting.

### Prerequisites

What things you need to install the software and how to install them

```
* Install Ant Migration Tool (or MavenMate, Force.com IDE)
* Install Git
```

## Running the tests

* Test classes can be run through the command line via a tool such as [forcedevtool](https://github.com/amtrack/force-dev-tool), Force.com IDE, or through the [Developer Console](https://developer.salesforce.com/page/Developer_Console)

## Deployment

* Download the repo
* Using [Ant Migration Tool](https://developer.salesforce.com/docs/atlas.en-us.daas.meta/daas/forcemigrationtool.htm) deploy to your sandbox for further testing

## Built With

* [Git](https://git-scm.com/) - Version Control System
* [Ant Migration Tool](https://developer.salesforce.com/docs/atlas.en-us.daas.meta/daas/forcemigrationtool_install.htm) - Used for exporting and importing metadata

## Versioning

I use [Git](https://git-scm.com/) for versioning.

## Helpful Links

* [Welcome to JSON2Apex](https://json2apex.herokuapp.com/)
* [Testing Best Practices](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_testing_best_practices.htm)
* [Service Bus access control with Shared Access Signatures](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-sas)
* [Best Practices for performance improvements using Service Bus Messaging](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-performance-improvements)
* [Unlock Message](https://docs.microsoft.com/en-us/rest/api/servicebus/unlock-message)

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](https://github.com/userraj/sfdc-microsoft-azure-service-bus/blob/master/LICENSE) file for details
