var Client = require('ssh2').Client;

var remote_ip =  process.env['REMOTE_IP'] || '127.0.0.1';
var remote_port =  process.env['REMOTE_PORT'] || 20022;
var local_ip =  process.env['REMOTE_IP'] || '0.0.0.0';
var local_port =  process.env['REMOTE_PORT'] || 10022;
var remote_ssh_ip =  process.env['REMOTE_SSH_IP'] || '192.168.11.11';
var remote_ssh_port =  process.env['REMOTE_SSH_PORT'] || 20022;
var remote_ssh_username =  process.env['REMOTE_SSH_USERNAME'] || 'land007';
var remote_ssh_password =  process.env['REMOTE_SSH_PASSWORD'] || '1234567';

var conn = new Client();
conn.on('ready', function() {
  console.log('Client :: ready');
  conn.forwardOut(remote_ip, remote_port, local_ip, local_port, function(err, stream) {
    if (err) throw err;
    stream.on('close', function() {
      console.log('TCP :: CLOSED');
      conn.end();
    }).on('data', function(data) {
      console.log('TCP :: DATA: ' + data);
    }).end([
      'HEAD / HTTP/1.1',
      'User-Agent: curl/7.27.0',
      'Host: 127.0.0.1',
      'Accept: */*',
      'Connection: close',
      '',
      ''
    ].join('\r\n'));
  });
}).connect({
  host: remote_ssh_ip,
  port: remote_ssh_port,
  username: remote_ssh_username,
  password: remote_ssh_password
});