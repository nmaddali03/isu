import { createContext, useState } from "react";

export const PageContext = createContext({
  page: "", // items | cart | confirmation
  setPage: (page) => {},
});

export const PageProvider = ({ children }) => {
  const [page, setPage] = useState("items");

  return (
    <PageContext.Provider value={{ page, setPage }}>
      {children}
    </PageContext.Provider>
  );
};
