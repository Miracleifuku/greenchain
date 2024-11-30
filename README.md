# GreenChain: Carbon Credit Trading Platform

**GreenChain** is a decentralized platform for trading verified carbon offset credits, aiming to support global efforts in reducing carbon emissions and promoting sustainability. The platform allows individuals and organizations to create, validate, transfer, and track carbon credits securely and transparently on the blockchain.

---

## Features
- **Carbon Credit Creation**: Issue new carbon credits with details such as volume, certification date, and validation authority.
- **Validation Authority Management**: Register and manage authorized validation authorities to ensure credit authenticity.
- **Credit Transfer**: Securely transfer carbon credits between parties on the platform.
- **Credit Validation**: Validate and certify carbon credits to make them trade-ready.
- **Tracking**: View details of any carbon credit and the total number of credits in the system.

---

## Smart Contract Details
### Data Structures
1. **`carbon-credits` (Map)**  
   Stores details about carbon credits, including their owner, volume, verification status, certification date, and associated validation authority.
   ```clarity
   {credit-id: uint} => {
       owner: principal,
       volume: uint,
       verification-status: bool,
       certification-date: uint,
       validation-authority: principal
   }
   ```

2. **`validation-authorities` (Map)**  
   Tracks authorized validation authorities and their reputation scores.
   ```clarity
   {principal} => {
       is-authorized: bool,
       reputation-score: uint
   }
   ```

3. **`total-system-credits` (Data Variable)**  
   Tracks the total number of carbon credits issued on the platform.

---

### Key Functions
#### Public Functions
1. **`create-carbon-credit`**  
   Creates a new carbon credit.  
   **Parameters**:
   - `volume` (uint): Carbon reduction volume in metric tons.
   - `validation-authority` (principal): Principal of the validating authority.  
   **Returns**: Credit ID (`uint`).

2. **`validate-carbon-credit`**  
   Validates a carbon credit, marking it as verified.  
   **Parameters**:
   - `credit-id` (uint): The ID of the credit to validate.  
   **Returns**: Boolean (`true` on success).

3. **`transfer-carbon-credit`**  
   Transfers ownership of a carbon credit to another principal.  
   **Parameters**:
   - `credit-id` (uint): ID of the credit to transfer.
   - `recipient` (principal): Recipient's principal.  
   **Returns**: Boolean (`true` on success).

4. **`register-validation-authority`**  
   Registers the caller as a validation authority.  
   **Returns**: Boolean (`true` on success).

5. **`get-carbon-credit-details`**  
   Fetches details of a specific carbon credit.  
   **Parameters**:
   - `credit-id` (uint): ID of the credit to retrieve.  
   **Returns**: Credit details (`optional`).

6. **`get-total-system-credits`**  
   Retrieves the total number of carbon credits in the system.  
   **Returns**: Total credits (`uint`).

#### Private Functions
1. **`is-valid-validator`**  
   Verifies if the given principal is an authorized validation authority.  
   **Parameters**:
   - `validator` (principal): Principal to validate.  
   **Returns**: Boolean (`true` if valid).

---

## Deployment
1. **Prerequisites**:
   - A Stacks blockchain development environment (e.g., Clarinet).
   - Access to the deployer's principal (to set `CONTRACT-OWNER`).

2. **Steps**:
   - Clone the repository:  
     ```bash
     git clone <repository-url>
     ```
   - Navigate to the project directory:  
     ```bash
     cd GreenChain
     ```
   - Deploy the contract using Clarinet:  
     ```bash
     clarinet deploy
     ```

---

## Testing
Run the following command to execute the test cases:
```bash
clarinet test
```
Ensure all test cases pass to verify the correctness of the contract's functionality.

---

## Future Enhancements
- Implement a marketplace for buying and selling carbon credits.
- Introduce a reputation-based system for validation authorities.
- Add analytics to track carbon credits across their lifecycle.

---

## License
This project is open-source under the MIT License. Contributions are welcome!

For more information, contact the project maintainer or refer to the documentation.