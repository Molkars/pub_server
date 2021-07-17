# Custom Pub Server

### Running
```bash
git clone https://github.com/Molkars/pub_server.git
cd pub_server
# CLI Options
# directory: String    | The directory in which to save packages, default: pub_server-repository-data
# host: String         | The host on which to run the server, default: localhost
# port: Integer String | The port on which to run the server, default: 8080 
# standalone: Boolean  | Whether or not to utilize the remote (pub.dev) repository
dart bin/pub_server.dart
```