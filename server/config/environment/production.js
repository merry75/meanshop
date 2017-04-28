'use strict';

// Production specific configuration
// =================================
module.exports = {
  // Server IP
  ip:       process.env.OPENSHIFT_NODEJS_IP ||
            process.env.IP ||
            undefined,

  // Server port
  port:     process.env.OPENSHIFT_NODEJS_PORT ||
            process.env.PORT ||
            8080,

  // MongoDB connection options
  mongo: {
    uri:    process.env.MONGOLAB_URI ||
            process.env.MONGOHQ_URL ||
            process.env.OPENSHIFT_MONGODB_DB_URL +
            process.env.OPENSHIFT_APP_NAME ||
            process.env.MONGODB_DB_URL ||
            'mongodb://merry75:123@ds123351.mlab.com:23351/meanshop-test'
  }
};


// mongodb://heroku_xs9hsgtf:rf96hgha2hpv143jaq3bn3cl81@ds133260.mlab.com:33260/heroku_xs9hsgtf
//mongodb://merry75:123@ds123351.mlab.com:23351/meanshop-test