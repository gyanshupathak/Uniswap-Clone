"use client";
import Image from "next/image";
import Navbar from "./components/navbar/page";
import { useState } from "react";
import { CircleX, Lock, Settings } from "lucide-react";
import ethLogo from "../../public/assets/Ethereum_logo_2014.svg.png";

export default function Home() {
  const [amount, setAmount] = useState("");
  const [showSettings, setShowSettings] = useState(false);
  const [isModal1Open, setModal1Open] = useState(false);
  const [isModal2Open, setModal2Open] = useState(false);
  const [selectedToken1, setSelectedToken1] = useState("ETH");
  const [selectedToken2, setSelectedToken2] = useState("ETH");
  const [transactionDeadlineEnabled, setTransactionDeadlineEnabled] =
    useState(false);

  const handleAmountChange = () => {
    console.log("handleAmountChange");
  };

  const handleConnectWallet = () => {
    console.log("Connect Wallet clicked");
  };

  const toggleSettings = () => {
    setShowSettings(!showSettings);
  };

  const toggleTransactionDeadline = () => {
    setTransactionDeadlineEnabled(!transactionDeadlineEnabled);
  };

  const openModal1 = () => setModal1Open(true);
  const closeModal1 = () => setModal1Open(false);
  const openModal2 = () => setModal2Open(true);
  const closeModal2 = () => setModal2Open(false);

  return (
    <>
      <Navbar />
      <div className="flex justify-center items-center min-h-screen bg-white">
        <div className="bg-white shadow-lg rounded-lg p-6 flex flex-col gap-2 w-96">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-2xl">{showSettings ? "Settings" : "Swap"}</h2>
            <Settings onClick={toggleSettings} className="cursor-pointer" />
          </div>

          {showSettings ? (
            <div className="flex flex-col space-y-4 gap-2">
              <label className="flex flex-col">
                <div className="flex flex-row gap-2 items-center mb-2">
                  Slippage Tolerance
                  <Lock className="w-4 h-4" />
                </div>
                <div className="flex flex-row gap-2 items-center">
                  <button className="flex items-center h-8 p-2 bg-pink-600 rounded text-white hover:bg-pink-700">
                    Auto
                  </button>
                  <input
                    type="range"
                    min="0"
                    max="5"
                    step="0.1"
                    className="mt-1 w-full"
                  />
                </div>
              </label>
              <label className="flex flex-col">
                <div className="flex flex-row gap-2 items-center">
                  Slippage Tolerance
                  <Lock className="w-4 h-4" />
                </div>
                <div className="flex flex-row gap-2 items-center">
                  <input
                    type="range"
                    min="0"
                    max="5"
                    step="0.1"
                    className="mt-1 w-full"
                  />
                  <button className="flex items-center p-2 h-8 bg-pink-600 rounded text-white hover:bg-pink-700">
                    Minutes
                  </button>
                </div>
              </label>
              <label className="flex justify-between items-center mt-4">
                Transaction Deadline
                <div className="flex items-center">
                  <span className="mr-2 text-gray-700">No</span>
                  <div
                    onClick={toggleTransactionDeadline}
                    className={`relative w-12 h-6 flex items-center bg-pink-600 rounded-full cursor-pointer transition ${
                      transactionDeadlineEnabled ? "bg-pink-600" : "bg-pink-300"
                    }`}
                  >
                    <div
                      className={`absolute w-6 h-6 bg-white rounded-full shadow transform transition border border-pink-400 ${
                        transactionDeadlineEnabled
                          ? "translate-x-6"
                          : "translate-x-0"
                      }`}
                    ></div>
                  </div>
                  <span className="ml-2 text-gray-700">Yes</span>
                </div>
              </label>
            </div>
          ) : (
            <>
              <div className="flex flex-row space-y-4">
                <div className="flex items-center justify-between gap-2 border border-Black-600 rounded-lg">
                  <input
                    type="text"
                    placeholder="0"
                    value={amount}
                    onChange={handleAmountChange}
                    className="rounded-lg p-2"
                  />
                  <button
                    className="flex items-center gap-2 bg-pink-600 text-white p-2 rounded-lg hover:bg-pink-700 w-3/4"
                    onClick={openModal1}
                  >
                    <Image
                      src={ethLogo}
                      alt="ETH Logo"
                      width={16}
                      height={16}
                    />
                    {selectedToken1} <span>234</span>
                  </button>
                </div>
              </div>

              <div className="flex flex-row space-y-4">
                <div className="flex items-center justify-between gap-2 border border-Black-600 rounded-lg">
                  <input
                    type="text"
                    placeholder="0"
                    value={amount}
                    onChange={handleAmountChange}
                    className="rounded-lg p-2"
                  />
                  <button
                    className="flex items-center gap-2 bg-pink-600 text-white p-2 rounded-lg hover:bg-pink-700 w-3/4"
                    onClick={openModal2}
                  >
                    <Image
                      src={ethLogo}
                      alt="ETH Logo"
                      width={16}
                      height={16}
                    />
                    {selectedToken2} <span>234</span>
                  </button>
                </div>
              </div>

              <div className="flex justify-center mt-6">
                <button
                  onClick={handleConnectWallet}
                  className="bg-pink-100 text-pink-700 px-4 py-2 rounded-lg hover:bg-pink-300"
                >
                  Connect Wallet
                </button>
              </div>
            </>
          )}
        </div>
      </div>
      {isModal1Open && (
        <div className="fixed gap-2 inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
          <div className="bg-white rounded-lg p-6 shadow-lg relative w-96">
            <button
              className="absolute top-7 right-4 text-gray-600"
              onClick={closeModal1}
            >
              <CircleX />
            </button>
            <div>
              <h2 className="text-2xl mb-4 text-pink-600">Your Token List</h2>
              <div className="flex flex-row gap-2">
                <button className="p-2 bg-pink-500 rounded hover:bg-pink-400 text-white">
                  <Image src={ethLogo} alt="ETH Logo" width={16} height={12} />
                </button>
                <button
                  className="p-2"
                  onClick={() => {
                    setSelectedToken1("ETH");
                    closeModal1();
                  }}
                >
                  ETH
                </button>
              </div>
              <hr className="my-2 border-t border-gray-300" />
              <div className="flex flex-row gap-2">
                <button className="p-2 bg-pink-500 rounded hover:bg-pink-400 text-white">
                  <Image src={ethLogo} alt="ETH Logo" width={16} height={12} />
                </button>
                <button
                  className="p-2"
                  onClick={() => {
                    setSelectedToken1("SOL");
                    closeModal1();
                  }}
                >
                  SOL
                </button>
              </div>
              <hr className="my-2 border-t border-gray-300" />
              <div className="flex flex-row gap-2">
                <button className="p-2 bg-pink-500 rounded hover:bg-pink-400 text-white">
                  <Image src={ethLogo} alt="ETH Logo" width={16} height={12} />
                </button>
                <button
                  className="p-2"
                  onClick={() => {
                    setSelectedToken1("UNI");
                    closeModal1();
                  }}
                >
                  UNI
                </button>
              </div>
              <hr className="my-2 border-t border-gray-300" />
              <div className="flex flex-row gap-2">
                <button className="p-2 bg-pink-500 rounded hover:bg-pink-400 text-white">
                  <Image src={ethLogo} alt="ETH Logo" width={16} height={12} />
                </button>
                <button
                  className="p-2"
                  onClick={() => {
                    setSelectedToken1("POL");
                    closeModal1();
                  }}
                >
                  POL
                </button>
              </div>
              <hr className="my-2 border-t border-gray-300" />
            </div>
          </div>
        </div>
      )}
      {isModal2Open && (
        <div className="fixed gap-2 inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
          <div className="bg-white rounded-lg p-6 shadow-lg relative w-96">
            <button
              className="absolute top-7 right-4 text-gray-600"
              onClick={closeModal2}
            >
              <CircleX />
            </button>
            <div>
              <h2 className="text-2xl mb-4 text-pink-600">Your Token List</h2>
              <div className="flex flex-row gap-2">
                <button className="p-2 bg-pink-500 rounded hover:bg-pink-400 text-white">
                  <Image src={ethLogo} alt="ETH Logo" width={16} height={12} />
                </button>
                <button
                  className="p-2"
                  onClick={() => {
                    setSelectedToken2("ETH");
                    closeModal2();
                  }}
                >
                  ETH
                </button>
              </div>
              <hr className="my-2 border-t border-gray-300" />
              <div className="flex flex-row gap-2">
                <button className="p-2 bg-pink-500 rounded hover:bg-pink-400 text-white">
                  <Image src={ethLogo} alt="ETH Logo" width={16} height={12} />
                </button>
                <button
                  className="p-2"
                  onClick={() => {
                    setSelectedToken2("SOL");
                    closeModal2();
                  }}
                >
                  SOL
                </button>
              </div>
              <hr className="my-2 border-t border-gray-300" />
              <div className="flex flex-row gap-2">
                <button className="p-2 bg-pink-500 rounded hover:bg-pink-400 text-white">
                  <Image src={ethLogo} alt="ETH Logo" width={16} height={12} />
                </button>
                <button
                  className="p-2"
                  onClick={() => {
                    setSelectedToken2("UNI");
                    closeModal2();
                  }}
                >
                  UNI
                </button>
              </div>
              <hr className="my-2 border-t border-gray-300" />
              <div className="flex flex-row gap-2">
                <button className="p-2 bg-pink-500 rounded hover:bg-pink-400 text-white">
                  <Image src={ethLogo} alt="ETH Logo" width={16} height={12} />
                </button>
                <button
                  className="p-2"
                  onClick={() => {
                    setSelectedToken2("POL");
                    closeModal2();
                  }}
                >
                  POL
                </button>
              </div>
              <hr className="my-2 border-t border-gray-300" />
            </div>
          </div>
        </div>
      )}
    </>
  );
}
