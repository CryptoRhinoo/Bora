# 🚀 BORA - Despliegue en Vercel

## 📋 Pasos para desplegar en Vercel:

### 1. **Preparar el repositorio:**
```bash
# Asegúrate de que todos los archivos estén en Git
git add .
git commit -m "Ready for Vercel deployment"
git push origin main
```

### 2. **Configurar variables de entorno en Vercel:**

Ve a tu proyecto en Vercel y agrega estas variables de entorno:

```
NEXT_PUBLIC_APP_URL=https://tu-app.vercel.app
NEXT_PUBLIC_APP_ICON=https://tu-app.vercel.app/icon.png
NEXT_PUBLIC_BORA_CONTRACT_ADDRESS=0x63B8f61F3657762487a6326304af08887E29D862
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=tu_walletconnect_project_id
```

### 3. **Desplegar en Vercel:**

#### Opción A: Desde el dashboard de Vercel
1. Ve a [vercel.com](https://vercel.com)
2. Importa tu repositorio de GitHub
3. Configura las variables de entorno
4. Haz clic en "Deploy"

#### Opción B: Desde la línea de comandos
```bash
# Instala Vercel CLI
npm i -g vercel

# Despliega
vercel

# Para producción
vercel --prod
```

### 4. **Verificar el despliegue:**

Una vez desplegado, verifica que:
- ✅ La aplicación carga correctamente
- ✅ El botón "Connect MetaMask" funciona
- ✅ MetaMask se conecta correctamente
- ✅ La red se cambia a Sepolia automáticamente
- ✅ Puedes ver tu dirección de wallet

### 5. **Configuración adicional (opcional):**

#### Agregar WalletConnect Project ID:
1. Ve a [cloud.walletconnect.com](https://cloud.walletconnect.com/)
2. Crea un nuevo proyecto
3. Copia el Project ID
4. Agrégalo como variable de entorno en Vercel

#### Configurar dominio personalizado:
1. En Vercel, ve a Settings > Domains
2. Agrega tu dominio personalizado
3. Configura los registros DNS según las instrucciones

## 🔧 Solución de problemas:

### Error de build:
- Verifica que todas las dependencias estén instaladas
- Asegúrate de que no haya errores de TypeScript
- Revisa la configuración de Next.js

### Error de conexión de wallet:
- Verifica que MetaMask esté instalado
- Asegúrate de estar en la red Sepolia
- Revisa la consola del navegador para errores

### Error de contrato:
- Verifica que la dirección del contrato sea correcta
- Asegúrate de que el contrato esté desplegado en Sepolia
- Revisa que el ABI coincida con el contrato

## 📱 URLs importantes:

- **Contrato en Sepolia:** [0x63B8f61F3657762487a6326304af08887E29D862](https://sepolia.etherscan.io/address/0x63B8f61F3657762487a6326304af08887E29D862)
- **WalletConnect:** [cloud.walletconnect.com](https://cloud.walletconnect.com/)
- **Vercel:** [vercel.com](https://vercel.com)

## 🎉 ¡Listo!

Tu aplicación BORA debería estar funcionando en Vercel con:
- ✅ Conexión de MetaMask
- ✅ Red Sepolia
- ✅ Interacción con el contrato BORA
- ✅ Interfaz responsive y moderna
