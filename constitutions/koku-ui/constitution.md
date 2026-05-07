# Koku UI — constitution

## Upstream repository

https://github.com/project-koku/koku-ui.git

## Mission

Monorepo for Cost Management user interfaces: multiple apps and shared libraries for HCCM, on-prem, ROS, and related surfaces. Work is coordinated with the broader Cost Management program (issues in Jira project COST).

## Tech stack

- Node.js and npm per root `engines` (Node >= 22.x, npm workspaces)
- TypeScript, webpack, React
- PatternFly v6 (`@patternfly/react-core`, charts, tables, component groups, icons)
- Cypress for UI testing where configured per app
- Root scripts orchestrate builds and on-prem dev flows across `apps/*` and `libs/*`
