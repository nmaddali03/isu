import { useContext, useState } from "react";
import { CartContext, items } from "../contexts/Cart";
import { PageContext } from "../contexts/Page";

const Authors = () => {
  return (
    <div>
      <p> 
        <span className="font-bold">Assignment02</span>
      </p>
      <p>
        <span className="font-bold">Names: </span> Katherine Amundson, Neha
        Maddali
      </p>
      <p>
        <span className="font-bold">NetIds: </span>kea1, nmaddali
      </p>
      <p>
        <span className="font-bold">Date: </span> November 5, 2023
      </p>
    </div>
  );
};

export const Items = () => {
  const { cart, addToCart, removeFromCart } = useContext(CartContext);
  const { setPage } = useContext(PageContext);
  const [searchTerm, setSearchTerm] = useState("");
  const [showToast, setShowToast] = useState(false);
  const [toastMessage, setToastMessage] = useState("");

  const filteredItems = items.filter((item) =>
    item.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const cartLength = cart.reduce((total, item) => total + item.quantity, 0);

  const handleAddToCart = (item) => {
    addToCart(item);
    setToastMessage(`Successfully added ${item.name} to cart!`);
    setShowToast(true);
    setTimeout(() => setShowToast(false), 3000);
  };

  const handleRemoveFromCart = (item) => {
    removeFromCart(item);
    setToastMessage(`Successfully removed ${item.name} from cart!`);
    setShowToast(true);
    setTimeout(() => setShowToast(false), 3000);
  };

  return (
    <div>
      {showToast && (
        <div className="fixed bottom-4 left-1/2 transform -translate-x-1/2 p-4 rounded bg-green-400 text-white z-50">
          {toastMessage}
        </div>
      )}
      <div className="bg-gradient-to-b from-gray-100 to-gray-300">
        <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 sm:py-12 lg:max-w-7xl lg:px-8">
          <div className="flex items-center justify-between">
            <h1 className="text-4xl font-bold tracking-tight text-gray-900 mr-40">
              Product Catalog
            </h1>
            <button
              onClick={() => setPage("cart")}
              type="button"
              className="flex gap-x-4 rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
            >
              <span className="sr-only">Items in cart, </span>
                {cartLength}
              <svg
                fill="none"
                stroke="currentColor"
                stroke-width="1.5"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
                aria-hidden="true"
                className="w-5 h-5"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z"
                ></path>
              </svg>
            </button>
          </div>

          <div className="mt-4">
            <input
              type="text"
              className="w-full px-3 py-2 border rounded-md"
              placeholder="Search for items..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>

          <div className="mt-6 grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-4 xl:gap-x-8">
            {filteredItems.map((item) => (
              <div>
                <div key={item.id} className="group relative">
                  <div className="aspect-h-1 aspect-w-1 w-full overflow-hidden bg-gray-200 lg:aspect-none lg:h-80 ">
                    <img
                      src={item.image}
                      alt={item.name}
                      className="h-full w-full object-cover object-center lg:h-full lg:w-full rounded-md border border-gray-500"
                    />
                  </div>
                  <div className="mt-4 flex justify-between">
                    <div>
                      <h3 className="text-sm text-gray-700">
                        <span aria-hidden="true" className="absolute inset-0" />
                        {item.name}
                      </h3>
                    </div>
                    <p className="text-sm font-medium text-gray-900">
                      ${item.price}
                    </p>
                  </div>
                  <p className="text-sm font-medium text-gray-900">
                    {item.description}
                  </p>
                </div>
                <div className="mt-4 flex gap-2">
                  <button
                    onClick={() => handleAddToCart(item)}
                    type="button"
                    className="w-full rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                  >
                    Add
                  </button>
                  <button
                    onClick={() => handleRemoveFromCart(item)}
                    type="button"
                    className="w-full rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                  >
                    Remove
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
        <Authors />
      </div>
    </div>
  );
};
