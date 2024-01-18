import { createContext, useState } from "react";

export const items = require("../items.json");

export const CartContext = createContext({
  cart: [],
  custName: "",
  streetAddress: "",
  city: "",
  state: "",
  zip: "",
  cardNumber: "",
  expirationDate: "",
  addToCart: (item) => {},
  removeFromCart: (item) => {},
  setName: (custName) => {},
  setStreetAddress: (streetAddress) => {},
  setExpirationDate: (expirationDate) => {},
  setCity: (city) => {},
  setState: (state) => {},
  setZip: (zip) => {},
  setCardNumber: (cardNumber) => {},
  setToastMessage: (message) => {},
  total: 0,
  subtotal: 0,
  taxes: 0,
  clearCart: () => {},
  resetForm: () => {},
});

export const CartProvider = ({ children }) => {
  const [cart, setCart] = useState([]);
  const [custName, setName] = useState("");
  const [streetAddress, setStreetAddress] = useState("");
  const [expirationDate, setExpirationDate] = useState("");
  const [city, setCity] = useState("");
  const [state, setState] = useState("");
  const [zip, setZip] = useState("");
  const [cardNumber, setCardNumber] = useState("");
  const [total, setTotal] = useState(0);
  const [subtotal, setSubtotal] = useState(0);
  const [taxes, setTaxes] = useState(0);
  const [toastMessage, setToastMessage] = useState("");
  const [showToast, setShowToast] = useState(false);  
  const cartLength = cart.reduce((total, item) => total + item.quantity, 0);


  const TAX_RATE = 0.07;

  const clearCart = () => {
    setCart([]);
    setSubtotal(0);
    setTotal(0);
    setTaxes(0);
  };


  const resetForm = () => {
    setName("");
    setStreetAddress("");
    setExpirationDate("");
    setCity("");
    setState("");
    setZip("");
    setCardNumber("");
  };

  // const addToCart = (item) => {
  //   const newCart = [...cart, item];

  //   let newSubtotal = newCart.reduce((acc, item) => acc + item.price, 0);
  //   newSubtotal = Math.round(newSubtotal * 100) / 100;
  //   const taxAmount = newSubtotal * TAX_RATE;
  //   const newTotal = Math.round((newSubtotal + taxAmount) * 100) / 100;

  //   setSubtotal(newSubtotal);
  //   setTotal(newTotal);
  //   setTaxes(taxAmount);
  //   setCart(newCart);
  // };


  // const removeFromCart = (item) => {
  //   setCart((prevCart) => {
  //     const index = prevCart.lastIndexOf(item);

  //     if (index < 0) return prevCart;

  //     const newCart = [
  //       ...prevCart.slice(0, index),
  //       ...prevCart.slice(index + 1, prevCart.length),
  //     ];

  //     const newSubtotal = newCart.reduce((acc, item) => acc + item.price, 0);
  //     const taxAmount = newSubtotal * TAX_RATE;
  //     setSubtotal(newSubtotal);
  //     setTaxes(taxAmount);
  //     setTotal(newSubtotal + taxAmount);

  //     return newCart;
  //   });
  // };

  const addToCart = (item) => {
    const newCart = [...cart];
    const itemIndex = newCart.findIndex((cartItem) => cartItem.id === item.id);

    if (itemIndex >= 0) {
      // If the item is already in the cart, increase its quantity
      newCart[itemIndex].quantity += 1;
            // If the quantity reaches zero, remove it from the cart
            if (newCart[itemIndex].quantity === 0) {
              newCart.splice(itemIndex, 1);
            }
      
    } else {
      // Otherwise, add it to the cart with quantity 1
      newCart.push({ ...item, quantity: 1 });
    }

    // Update subtotal, total, and taxes
    const newSubtotal = newCart.reduce((acc, cartItem) => acc + cartItem.price * cartItem.quantity, 0);
    const taxAmount = newSubtotal * TAX_RATE;
    const newTotal = newSubtotal + taxAmount;

    setSubtotal(newSubtotal);
    setTotal(newTotal);
    setTaxes(taxAmount);
    setCart(newCart);
  };

  const removeFromCart = (item) => {
    setCart((prevCart) => {
      const newCart = [...prevCart];
      const itemIndex = newCart.findIndex((cartItem) => cartItem.id === item.id);

      if (itemIndex >= 0) {
        // If the item is in the cart, decrease its quantity
        newCart[itemIndex].quantity -= 1;
        if (newCart[itemIndex].quantity === 0) {
          // If the quantity reaches zero, remove it from the cart
          newCart.splice(itemIndex, 1);
        }
      }

      // Update subtotal, total, and taxes
      const newSubtotal = newCart.reduce((acc, cartItem) => acc + cartItem.price * cartItem.quantity, 0);
      const taxAmount = newSubtotal * TAX_RATE;
      setSubtotal(newSubtotal);
      setTaxes(taxAmount);
      setTotal(newSubtotal + taxAmount);

      return newCart;
    });
  };



  return (
    <CartContext.Provider
      value={{
        cart,
        addToCart,
        removeFromCart,
        toastMessage,
        showToast,
        setShowToast,
        setToastMessage,
        custName,
        setName,
        streetAddress,
        setStreetAddress,
        expirationDate,
        setExpirationDate,
        city,
        setCity,
        state,
        setState,
        zip,
        setZip,
        cardNumber,
        setCardNumber,
        total,
        subtotal,
        taxes,
        clearCart,
        cartLength,
        resetForm,
      }}
    >
      {children}
    </CartContext.Provider>
  );
};
