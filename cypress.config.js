const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    baseUrl: 'http://localhost:8080/exist/apps/majlis-editions',
    specPattern: 'cypress/e2e/**/*.cy.{js,jsx,ts,tsx}',

    defaultCommandTimeout: 15000,
    pageLoadTimeout: 30000,
    requestTimeout: 15000,

    video: false,
    screenshotOnRunFailure: true,

    supportFile: false,

    retries: {
      runMode: 1,
      openMode: 0,
    },

    setupNodeEvents(on, config) {
    },
  },
})
