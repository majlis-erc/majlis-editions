describe('index.html elements', () => {
    beforeEach(() => {
        cy.visit('/')
    })

    it('show the logo', () => {
        cy.get('body > pb-page > app-drawer-layout > app-header-layout > app-header > app-toolbar > a')
            .should('exist')
    })
    it('should have a title', () => {
        cy.get('body > pb-page > app-drawer-layout > app-header-layout > main > section:nth-child(1) > h1')
            .should('exist')
    })

    it('should show the content', () => {
        cy.get('#document-list > pb-load > div > div > div > ul')
            .should('have.descendants', 'li')
            .its('length').should('be.gt', 0)
    })

    it('search for a term', () => {
        cy.get('#input-5 > input[type=search]', { includeShadowDom: true })
            .type('haven')

        cy.get('#search-form > paper-button', { includeShadowDom: true })
            .click()

        // make sure the backend is getting the query
        cy.url().should('include', '?query=haven&collection=&sort=category&field=text&start=1')

        // make sure the frontend is getting the results
        cy.get('#paginate', { includeShadowDom: true }).shadow().find('span.found')
            .should('have.text', 'Found 1 item')
    })

})