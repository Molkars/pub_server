# Custom Pub Server

### CLI Options
| **name** | **type** | **The description of the option** | **Default Value** | 
| ---- | ---- | ------------------------------------------------------------ | -------------------------- |
| directory | String | The directory in which to save packages | pub_server-repository-data |
| host | String | The host on which to run the server | localhost |
| port | Integer String | The port on which to run the server | 8080 | 
| standalone | Boolean | If the server should NOT use the remote repository (pub.dev) | false |

### Running
```bash
git clone https://github.com/Molkars/pub_server.git
cd pub_server
dart bin/pub_server.dart
```