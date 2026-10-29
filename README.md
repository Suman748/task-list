# Task List

React + Vite frontend for the Sketchverse Task Management application.

Day 3: responsive task list component built with mock data.

## Features

- Task cards showing title, assignee and estimated hours
- Status dropdown on each task (Not Started, In Progress, Done)
- Search box to filter tasks by title
- Status filter and live task count
- Responsive layout: 1 column on mobile, 2 columns on desktop

## Run locally

Install dependencies:

```bash
npm install
```

Start the development server:

```bash
npm run dev
```

Build for production:

```bash
npm run build
```

## Project structure

```
src/
  App.jsx        # page layout, search and filter state
  TaskList.jsx   # responsive list component
  mockTasks.js   # mock data and status options
  App.css        # styles and media queries
```
