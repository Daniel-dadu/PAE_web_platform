import { SMTPClient } from 'emailjs';
// const SMTPClient = require('emailjs').SMTPClient
import web from './credentials.js'

// const client = new SMTPClient(web.web);
// const client = new SMTPClient({
// 	user: 'paetecpuebla@gmail.com',
// 	password: 'SMTPserver2022',
// 	host: 'smtp.gmail.com',
// 	ssl: true,
//     logger: web.web
// });
const client = new SMTPClient({
	user: 'paewebplatform@eloasticsmtp.com',
	password: '7E4975F0A9F6AFFD5252825AB4CDD98CFC94',
	host: 'smtp.elasticemail.com',
    port: 2525
});

// send the message and get a callback with an error or details of the message that was sent
client.send(
	{
		text: 'i hope this works',
		from: 'Pae <paetecpuebla@gmail.com>',
		to: 'Dadu <dadu9494@gmail.com>',
		cc: '',
		subject: 'testing emailjs',
	},
	(err, message) => {
		console.log(err || message);
	}
);