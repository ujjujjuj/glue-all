require('dotenv').config();
const express = require('express');
const cors = require('cors')
const { Init } = require('./services/elastic');

const dataRoutes = require('./routes/elastic');
const { attachClient } = require('./middleware/elastic');

const app = express();

const PORT = process.env.PORT || 3000

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }))


elasticClient = Init() // init elastic client

app.use('/api/elastic', attachClient(elasticClient), dataRoutes);

elasticClient.info()
    .then(_ => {
        app.listen(PORT, () => {
            console.log('[-] connected to port:', PORT)
        })
    })
    .catch(err => {
        console.log(err);
    })
