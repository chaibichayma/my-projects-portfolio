import express from "express";
import User from "../models/User.js";

const router = express.Router();

router.post("/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;
    if (!name || !email || !password) {
      return res.status(400).json({ message: "Please fill all fields" });
    }
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists" });
    }
    const newUser = new User({ name, email, password });
    await newUser.save();
    res.status(201).json({ message: "User created successfully", user: newUser });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ message: "Fill all fields" });

  const user = await User.findOne({ email });
  if (!user) return res.status(400).json({ message: "User not found" });

  if (user.password !== password) return res.status(400).json({ message: "Wrong password" });

  res.status(200).json({ message: "Login successful", user });
});

router.post("/like-product", async (req, res) => {

  const { userId, productId } = req.body;

  try {

    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const alreadyLiked = user.likedProducts.includes(productId);

    if (alreadyLiked) {
      user.likedProducts = user.likedProducts.filter(
        (id) => id.toString() !== productId
      );
    } else {
      user.likedProducts.push(productId);
    }

    await user.save();

    res.json({
      message: "Updated",
      likedProducts: user.likedProducts
    });

  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
});

router.post("/add-to-cart", async (req, res) => {

  const { userId, productId } = req.body;

  try {

    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const alreadyInCart = user.cartProducts.includes(productId);

    if (!alreadyInCart) {
      user.cartProducts.push(productId);
    }

    await user.save();

    res.json({
      message: "Product added to cart",
      cartProducts: user.cartProducts
    });

  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }

});

router.post("/remove-from-cart", async (req, res) => {

  const { userId, productId } = req.body;

  try {

    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    user.cartProducts = user.cartProducts.filter(
      id => id.toString() !== productId
    );

    await user.save();

    res.json({
      message: "Product removed from cart",
      cartProducts: user.cartProducts
    });

  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }

});

export default router;