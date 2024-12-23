"use client";
import Image from "next/image";
import Link from "next/link";
import React, { useState } from "react";
import logo from "../../../../public/assets/Uniswap_Logo.svg.png";
import ethlogo from "../../../../public/assets/Ethereum_logo_2014.svg.png";
import { CircleX, CrossIcon, Settings } from "lucide-react";
import metamaskLogo from "../../../../public/assets/MetaMask_Fox.svg.png";
import coinbase from "../../../../public/assets/coinbaseLogo.png";

const Navbar = () => {
  const [isModalOpen, setModalOpen] = useState(false);
  const [isConnected, setIsConnected] = useState(false);

  const openModal = () => setModalOpen(true);
  const closeModal = () => setModalOpen(false);

  const handleConnectWallet = () => {
    console.log("Connected Wallet");
    setIsConnected(true);
    setModalOpen(false);
  };

  console.log("isConnected", isConnected);

  return (
    <nav className="flex items-center justify-between p-4 bg-white text-Black-300">
      <div className="flex items-center space-x-4">
        <div className="flex items-center text-xl text-pink-500">
          <Image src={logo} alt="Logo" width={40} height={40} />
          <span className="mr-4">Uniswap</span>
        </div>
        <div className="flex space-x-4">
          <Link href="/swap" className="hover:text-gray-400">
            Swap
          </Link>
          <Link href="/tokens" className="hover:text-gray-400">
            Tokens
          </Link>
          <Link href="/pool" className="hover:text-gray-400">
            Pool
          </Link>
        </div>
      </div>

      <div className="flex justify-center flex-grow">
        <input
          type="text"
          placeholder="Search Tokens..."
          className="w-1/2 p-2 rounded bg-White-300 border border-White-700 text-White-800 placeholder-gray-400 focus:outline-none"
        />
      </div>

      <div className="flex items-center space-x-4">
        <button className="bg-pink-100 px-4 py-2 rounded-3xl hover:bg-pink-300 text-pink-600 flex items-center">
          <Image src={ethlogo} alt="Logo" width={10} height={10} />
          <span className="pl-2">Network</span>
        </button>
        <button
          className="bg-pink-100 px-4 py-2 rounded-3xl hover:bg-pink-300 text-pink-600"
          onClick={openModal}
        >
          {isConnected ? "Choose Token" : "Connect"}
        </button>
      </div>

      {isModalOpen && (
        <div className="fixed gap-2 inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
          <div className="bg-white rounded-lg p-6 shadow-lg relative w-96">
            <button
              className="absolute top-7 right-4 text-gray-600"
              onClick={closeModal}
            >
              <CircleX />
            </button>
            {isConnected ? (
              <div>
                <h2 className="text-2xl mb-4 text-pink-600">Your Token List</h2>
                <div className="flex flex-row gap-2">
                  <button className="p-2 bg-pink-500 rounded hover:bg-gray-200 text-white">
                    Hey
                  </button>
                  <div className="p-2 text-pink-500">24</div>
                  <button className="p-2">Gold Coin</button>
                </div>
                <hr className="my-2 border-t border-gray-300" />
                <div className="flex flex-row gap-2">
                  <button className="p-2 bg-pink-500 rounded hover:bg-gray-200 text-white">
                    Hey
                  </button>
                  <div className="p-2 text-pink-500">24</div>
                  <button className="p-2">Gold Coin</button>
                </div>
                <hr className="my-2 border-t border-gray-300" />
                <div className="flex flex-row gap-2">
                  <button className="p-2 bg-pink-500 rounded hover:bg-gray-200 text-white">
                    Hey
                  </button>
                  <div className="p-2 text-pink-500">24</div>
                  <button className="p-2">Gold Coin</button>
                </div>
                <hr className="my-2 border-t border-gray-300" />
                <div className="flex flex-row gap-2">
                  <button className="p-2 bg-pink-500 rounded hover:bg-gray-200 text-white">
                    Hey
                  </button>
                  <div className="p-2 text-pink-500">24</div>
                  <button className="p-2">Gold Coin</button>
                </div>
                <hr className="my-2 border-t border-gray-300" />
                <div className="flex flex-row gap-2">
                  <button className="p-2 bg-pink-500 rounded hover:bg-gray-200 text-white">
                    Hey
                  </button>
                  <div className="p-2 text-pink-500">24</div>
                  <button className="p-2">Gold Coin</button>
                </div>
                <hr className="my-2 border-t border-gray-300" />
                <div className="flex flex-row gap-2">
                  <button className="p-2 bg-pink-500 rounded hover:bg-gray-200 text-white">
                    Hey
                  </button>
                  <div className="p-2 text-pink-500">24</div>
                  <button className="p-2">Gold Coin</button>
                </div>
                <hr className="my-2 border-t border-gray-300" />
                <div className="flex flex-row gap-2">
                  <button className="p-2 bg-pink-500 rounded hover:bg-gray-200 text-white">
                    Hey
                  </button>
                  <div className="p-2 text-pink-500">24</div>
                  <button className="p-2">Gold Coin</button>
                </div>
                <hr className="my-2 border-t border-gray-300" />
              </div>
            ) : (
              <div>
                <h2 className="text-2xl mb-4 text-pink-600">
                  Connect a Wallet
                </h2>
                <div className="flex flex-col space-y-3">
                  <button
                    className="flex items-center p-2 bg-gray-100 rounded hover:bg-gray-200"
                    onClick={handleConnectWallet}
                  >
                    <Image
                      src={coinbase}
                      alt="coinbase"
                      width={24}
                      height={24}
                    />
                    <span className="ml-2">Coinbase Wallet</span>
                  </button>
                  <button
                    className="flex items-center p-2 bg-gray-100 rounded hover:bg-gray-200"
                    onClick={handleConnectWallet}
                  >
                    <Image
                      src={metamaskLogo}
                      alt="metamask"
                      width={24}
                      height={24}
                    />
                    <span className="ml-2">Metamask Wallet</span>
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </nav>
  );
};

export default Navbar;
