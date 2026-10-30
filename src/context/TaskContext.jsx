import { createContext, useContext, useState } from "react";
import initialTasks from "../data/mockTasks";

const TaskContext = createContext(null);

export function TaskProvider({ children }) {
  const [tasks, setTasks] = useState(initialTasks);

  const addTask = (task) =>
    setTasks((prev) => [...prev, { ...task, id: Date.now() }]);

  const updateTask = (id, updates) =>
    setTasks((prev) => prev.map((t) => (t.id === id ? { ...t, ...updates } : t)));

  return (
    <TaskContext.Provider value={{ tasks, addTask, updateTask }}>
      {children}
    </TaskContext.Provider>
  );
}

export const useTasks = () => useContext(TaskContext);
