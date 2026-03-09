# Deli

A TLA⁺ specification of a simple deli ordering system with a ticket-queue model.

The spec models a single worker serving customers in queue order. Customers arrive, receive a ticket number, join an order queue, get assigned to the worker, receive service, and the system resets to serve the next customer. The system cycles through four states: Idle → TakingOrder → PreparingOrder → Serving → ReturnToIdle.

## Key Features

- **Ticket-based ordering**: Customers get monotonically increasing ticket numbers as they arrive
- **Queue discipline**: Customers are served in FIFO order from the queue
- **Worker assignment**: A dedicated worker is assigned in the PrepareOrder phase
- **State machine with return cycle**: Unlike simpler queue models, the system explicitly returns to Idle, enabling liveness properties

## Properties Checked

The specification includes three safety invariants and one liveness property:

1. **TypeOK**: State variables maintain correct types throughout execution
2. **ValidStates**: The system never enters an undefined state
3. **MutualExclusion**: At most one customer-worker pair is in the Serving state at any time
4. **EventuallyIdle**: The system eventually returns to the Idle state (progress/fairness)

The `.tla` file includes formal THEOREM declarations for each property, making the spec suitable for TLC model checking and serving as a test case for the TLC toolchain.
