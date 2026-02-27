const { Builder, By, until } = require('selenium-webdriver');

describe('Dashboard UI Tests (Selenium)', () => {
    let driver;

    beforeAll(async () => {
        // Requires chromedriver to be installed or available in PATH
        driver = await new Builder().forBrowser('chrome').build();
    });

    afterAll(async () => {
        await driver.quit();
    });

    it('should display login form on load', async () => {
        await driver.get('http://localhost:8080'); // Adjust to your frontend port
        const loginForm = await driver.wait(until.elementLocated(By.css('[data-testid="login-form"]')), 5000);
        expect(await loginForm.isDisplayed()).toBe(true);
    });

    it('should successfully login and display dashboard stats', async () => {
        await driver.findElement(By.css('[data-testid="email-input"]')).sendKeys('test@example.com');
        await driver.findElement(By.css('[data-testid="password-input"]')).sendKeys('password123'); // Password isn't validated per Deliverable 1
        await driver.findElement(By.css('[data-testid="login-button"]')).click();

        const dashboard = await driver.wait(until.elementLocated(By.css('[data-testid="dashboard"]')), 5000);
        expect(await dashboard.isDisplayed()).toBe(true);

        const apiCredentials = await driver.findElement(By.css('[data-testid="api-credentials"]'));
        expect(await apiCredentials.isDisplayed()).toBe(true);

        const statsContainer = await driver.findElement(By.css('[data-testid="stats-container"]'));
        expect(await statsContainer.isDisplayed()).toBe(true);

        const totalTransactions = await driver.findElement(By.css('[data-testid="total-transactions"]'));
        expect(await totalTransactions.isDisplayed()).toBe(true);
    });
});
