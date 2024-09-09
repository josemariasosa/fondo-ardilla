# Ejercicio de Implementación de ERC4626

Este repositorio es un ejercicio sencillo diseñado para los participantes del hackathon de ETH Mexico, con el fin de mostrar cómo implementar un contrato ERC4626.

## Instrucciones

### 1. Crear un nuevo proyecto de Hardhat

Inicializar el proyecto:

```bash
yarn init
```

Instalar Hardhat como dependencia de desarrollo:

```bash
yarn add --dev hardhat
```

Inicializar Hardhat:

```bash
yarn hardhat init
```

### 2. Instalar las dependencias necesarias

Una vez que tengan el proyecto de Hardhat configurado, deberán instalar los siguientes paquetes:

Instalar los contratos de OpenZeppelin:

```bash
yarn add @openzeppelin/contracts
```

Instalar la interfaz de Aave:

```bash
yarn add @aave/core-v3
```

### 3. Crear un archivo .env

Deberán crear un archivo .env en la raíz del proyecto con la siguiente información:

```makefile
INFURA_KEY="xxxxxxx"
BLOCK_NUMBER="250775774"
```

**Nota**: Es necesario generar una clave de Infura para conectarse a la blockchain.

### 4. Descripción del repositorio

Este repositorio tiene como objetivo educativo mostrar cómo se puede trabajar con contratos inteligentes y el estándar ERC-4626 en un entorno controlado. Es importante señalar que no se recomienda implementar estos contratos en la mainnet sin un análisis exhaustivo y pruebas detalladas.

En este repositorio encontrarás:

- Cómo hacer un fork de la mainnet de Arbitrum One: Aprenderás a replicar el estado de la mainnet para realizar pruebas en un entorno de desarrollo local.
- Cómo suplantar cuentas de la mainnet: Podrás probar diferentes escenarios utilizando los saldos de cuentas reales de la mainnet, facilitando la simulación de diferentes estrategias y comportamientos.
- Boilerplate de pruebas para contratos en Hardhat: El repositorio ya incluye código base para empezar a escribir pruebas unitarias y funcionales sobre los contratos desplegados.
- Implementación del estándar ERC-4626: El contrato sigue este estándar para demostrar cómo funcionan los "Vaults" (bóvedas) que administran activos tokenizados en diferentes estrategias.

### 5. Advertencia

Este repositorio es exclusivamente para fines educativos. Se recomienda encarecidamente no implementar estos contratos en la mainnet sin realizar un análisis profundo de seguridad, optimización, y pruebas exhaustivas.