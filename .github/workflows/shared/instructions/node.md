# Node.js / JavaScript / TypeScript Migration Instructions

## Detection
- **Config file:** `package.json`
- **Version manager:** `nvm` (`.nvmrc`), `volta` (`volta` field in `package.json`), `fnm`
- **Framework detection:** Check `dependencies` and `devDependencies` in `package.json`

## Framework Detection

| Package in dependencies | Framework |
|------------------------|-----------|
| `react`, `react-dom` | React |
| `next` | Next.js |
| `@angular/core` | Angular |
| `vue` | Vue.js |
| `nuxt` | Nuxt.js |
| `svelte` | Svelte |
| `express` | Express.js |
| `fastify` | Fastify |
| `@nestjs/core` | NestJS |

## Package Manager Detection

| Lock File | Manager | Commands |
|-----------|---------|----------|
| `package-lock.json` | npm | `npm install`, `npm test` |
| `yarn.lock` | yarn | `yarn install`, `yarn test` |
| `pnpm-lock.yaml` | pnpm | `pnpm install`, `pnpm test` |
| `bun.lockb` | bun | `bun install`, `bun test` |

## Commands Reference

### npm
| Action | Command |
|--------|---------|
| Install | `npm install` |
| Check outdated | `npm outdated` |
| Update | `npm update` |
| Update major | `npx npm-check-updates -u && npm install` |
| Audit | `npm audit` |
| Audit fix | `npm audit fix` |
| Test | `npm test` |
| Build | `npm run build` |
| Lint | `npx eslint .` |
| Type check | `npx tsc --noEmit` |

### yarn
| Action | Command |
|--------|---------|
| Install | `yarn install` |
| Check outdated | `yarn outdated` |
| Update interactive | `yarn upgrade-interactive --latest` |
| Audit | `yarn audit` |
| Test | `yarn test` |
| Build | `yarn build` |

### pnpm
| Action | Command |
|--------|---------|
| Install | `pnpm install` |
| Check outdated | `pnpm outdated` |
| Update | `pnpm update --latest` |
| Audit | `pnpm audit` |
| Test | `pnpm test` |
| Build | `pnpm build` |

## Common Breaking Changes

### React 18 → 19
- `ReactDOM.render()` → `createRoot().render()`
- `forwardRef` no longer needed — `ref` is a regular prop
- `useContext` → `use(Context)`
- `React.lazy` accepts named exports
- `ref` callbacks receive cleanup function

### Next.js 14 → 15
- Async Request APIs (`cookies()`, `headers()`, `params`, `searchParams` are now async)
- `next/image` changes
- Route Handlers default to dynamic

### Angular 17 → 18+
- Standalone components by default
- New control flow syntax (`@if`, `@for`, `@switch`)
- Signal-based inputs/outputs
- `inject()` function preferred over constructor injection

### Vue 3.4+
- `defineModel()` stable
- Improved `v-bind` same-name shorthand
- `MathML` support

### TypeScript 5.x
- `moduleResolution: "bundler"` recommended
- Decorators (Stage 3) supported natively
- `satisfies` operator
- `const` type parameters

### ESLint 9
- Flat config (`eslint.config.js`) replaces `.eslintrc`
- Many rules moved to `@eslint/js`

## Node.js Version Upgrades

| LTS Version | EOL | Key Changes |
|-------------|-----|-------------|
| Node 18 | Apr 2025 | Fetch API, test runner, watch mode |
| Node 20 | Apr 2026 | Stable test runner, permission model |
| Node 22 | Apr 2027 | require(esm), WebSocket, glob/globSync |

### Migration Steps for Node.js Version Upgrade
1. Update `.nvmrc` or `.node-version`
2. Update `engines` field in `package.json`
3. Update CI/CD pipeline Node version
4. Update Docker base image
5. Check for native module compatibility
6. Review deprecated APIs: `node --pending-deprecation`

## Codemods

| Framework | Codemod Tool |
|-----------|-------------|
| React | `npx @codemod/cli react/[codemod]` |
| Next.js | `npx @next/codemod [codemod-name] .` |
| Angular | `ng update @angular/core @angular/cli` |
| Vue | `npx vue-codemod [transform] [path]` |
| ESLint | `npx @eslint/migrate-config .eslintrc.json` |

## TypeScript Configuration

Recommended `tsconfig.json` for modern projects:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true
  }
}
```
