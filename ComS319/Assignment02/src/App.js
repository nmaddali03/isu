import { useContext } from "react";
import { PageContext } from "./contexts/Page";
import { Items } from "./pages/Items";
import { Cart } from "./pages/Cart";
import { Confirmation } from "./pages/Confirmation";

export const App = () => {
  const { page } = useContext(PageContext);

  // verify what pages are being used
  if (page === "items") {
    return <Items />;
  }

  if (page === "cart") {
    return <Cart />;
  }

  if (page === "confirmation") {
    return <Confirmation />;
  }

  // if the page is not listed, return an error message
  return <div>Page not found.</div>;
};
