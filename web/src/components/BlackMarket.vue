<template>
  <div class="black-market-container" v-show="isVisible">
    <div class="matrix-bg"></div>
    <div class="container">
      <!-- Sidebar -->
      <div class="sidebar">
        <div class="logo">
          <h1>BLACK MARKET</h1>
          <p>SECURE • ANONYMOUS • UNTRACEABLE</p>
        </div>
        
        <div class="bitcoin-wallet">
          <h3>₿ Bitcoin Wallet</h3>
          <div class="bitcoin-amount">{{ formatBitcoin(playerBitcoin) }}</div>
        </div>
        
        <div class="nav-tabs">
          <button 
            class="nav-tab" 
            :class="{ active: currentTab === 'market' }"
            @click="switchTab('market')"
          >
            Market
          </button>
          <button 
            class="nav-tab" 
            :class="{ active: currentTab === 'inventory' }"
            @click="switchTab('inventory')"
          >
            Inventory
          </button>
        </div>
        
        <div class="filters">
          <input 
            type="text" 
            class="search-box" 
            placeholder="Search items..." 
            v-model="searchQuery"
            @input="filterItems"
          >
          
          <div class="filter-group">
            <label>Category</label>
            <select class="filter-select" v-model="categoryFilter" @change="filterItems">
              <option value="all">All Categories</option>
              <option value="weapon">Weapons</option>
              <option value="drug">Drugs</option>
              <option value="ammo">Ammunition</option>
              <option value="illegal">Illegal Items</option>
            </select>
          </div>
          
          <div class="filter-group">
            <label>Rarity</label>
            <select class="filter-select" v-model="rarityFilter" @change="filterItems">
              <option value="all">All Rarities</option>
              <option value="common">Common</option>
              <option value="uncommon">Uncommon</option>
              <option value="rare">Rare</option>
              <option value="epic">Epic</option>
              <option value="legendary">Legendary</option>
            </select>
          </div>
        </div>
      </div>
      
      <!-- Main Content -->
      <div class="main-content">
        <div class="header">
          <h2>Underground Market</h2>
          <div class="market-status">
            <div class="status-indicator">
              <div class="status-dot"></div>
              <span>Market Online</span>
            </div>
            <div class="status-indicator">
              <div class="status-dot" style="background: #ff8c00;"></div>
              <span>High Activity</span>
            </div>
            <button class="btn btn-buy" @click="refreshMarket">Refresh Market</button>
          </div>
        </div>
        
        <!-- Market View -->
        <div v-if="currentTab === 'market'" class="market-view">
          <div class="items-grid">
            <div 
              v-for="item in filteredItems" 
              :key="item.itemName"
              class="item-card"
              @click="selectItem(item)"
            >
              <div class="item-header">
                <div class="item-name">{{ item.name }}</div>
                <div class="item-rarity" :class="`rarity-${item.rarity}`">
                  {{ item.rarity }}
                </div>
              </div>
              <div class="item-image">{{ item.emoji }}</div>
              <div class="item-description">{{ item.description }}</div>
              <div class="item-stats">
                <div class="stat">
                  <div class="stat-value">{{ Math.round(item.demand) }}%</div>
                  <div class="stat-label">Demand</div>
                </div>
                <div class="stat">
                  <div class="stat-value">{{ Math.round(item.supply) }}</div>
                  <div class="stat-label">Supply</div>
                </div>
              </div>
              <div class="price-section">
                <div class="price">
                  ₿ {{ formatBitcoin(item.price) }}
                  <span 
                    class="price-change" 
                    :class="item.priceChange >= 0 ? 'price-up' : 'price-down'"
                  >
                    {{ item.priceChange >= 0 ? '+' : '' }}{{ item.priceChange.toFixed(1) }}%
                  </span>
                </div>
              </div>
              <div class="action-buttons">
                <button 
                  class="btn btn-buy" 
                  @click.stop="buyItem(item)"
                  :disabled="getMaxAffordable(item) < 1"
                >
                  Buy (Max: {{ getMaxAffordable(item) }})
                </button>
                <button 
                  class="btn btn-sell" 
                  @click.stop="sellItem(item)"
                  :disabled="!hasInInventory(item.itemName)"
                >
                  Sell
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Inventory View -->
        <div v-if="currentTab === 'inventory'" class="inventory-view">
          <div class="inventory-section">
            <h3>Your Inventory</h3>
            <div class="inventory-grid">
              <div 
                v-for="item in playerInventory" 
                :key="item.itemName"
                class="inventory-item"
              >
                <h4>{{ item.name }}</h4>
                <div class="inventory-quantity">Quantity: {{ item.quantity }}</div>
                <div class="inventory-value">
                  Value: ₿ {{ formatBitcoin(calculateItemValue(item)) }}
                </div>
                <button 
                  class="btn btn-sell" 
                  @click="sellInventoryItem(item)"
                >
                  Sell (₿ {{ formatBitcoin(getSellPrice(item.itemName)) }} each)
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Transaction Modal -->
    <div v-if="showModal" class="modal" @click="closeModal">
      <div class="modal-content" @click.stop>
        <span class="close" @click="closeModal">&times;</span>
        <h3>{{ modalTitle }}</h3>
        <div class="transaction-details">
          <p><strong>Item:</strong> {{ currentTransaction.item?.name }}</p>
          <p><strong>{{ currentTransaction.type === 'buy' ? 'Price' : 'Sell Price' }}:</strong> 
             ₿ {{ formatBitcoin(currentTransaction.price) }} each</p>
          <p><strong>{{ currentTransaction.type === 'buy' ? 'Your Balance' : 'You Have' }}:</strong> 
             {{ currentTransaction.type === 'buy' ? '₿ ' + formatBitcoin(playerBitcoin) : currentTransaction.maxQuantity + ' units' }}</p>
          <p><strong>{{ currentTransaction.type === 'buy' ? 'Max Quantity' : 'Total Value' }}:</strong> 
             {{ currentTransaction.type === 'buy' ? currentTransaction.maxQuantity : '₿ ' + formatBitcoin(currentTransaction.totalValue) }}</p>
          <p><strong>Description:</strong> {{ currentTransaction.item?.description }}</p>
        </div>
        <input 
          type="number" 
          class="quantity-input" 
          v-model="transactionQuantity"
          :min="1"
          :max="currentTransaction.maxQuantity"
          placeholder="Enter quantity"
          @input="updateTotalCost"
        >
        <div v-if="totalCost > 0" class="total-display">
          <p><strong>{{ currentTransaction.type === 'buy' ? 'Total Cost' : 'Total Earning' }}:</strong> 
             ₿ {{ formatBitcoin(totalCost) }}</p>
        </div>
        <div class="modal-buttons">
          <button class="btn btn-buy" @click="confirmTransaction">Confirm</button>
          <button class="btn btn-sell" @click="closeModal">Cancel</button>
        </div>
      </div>
    </div>
    
    <!-- Notification -->
    <div v-if="notification.show" class="notification" :class="notification.type">
      {{ notification.message }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'BlackMarket',
  data() {
    return {
      isVisible: false,
      currentTab: 'market',
      searchQuery: '',
      categoryFilter: 'all',
      rarityFilter: 'all',
      
      // Market data
      marketData: [],
      filteredItems: [],
      playerBitcoin: 0,
      playerInventory: [],
      
      // Transaction modal
      showModal: false,
      modalTitle: '',
      currentTransaction: {},
      transactionQuantity: 1,
      totalCost: 0,
      
      // Notification
      notification: {
        show: false,
        message: '',
        type: 'info'
      }
    }
  },
  
  mounted() {
    this.setupEventListeners();
    this.setupKeyboardShortcuts();
  },
  
  methods: {
    setupEventListeners() {
      // Listen for NUI messages
      window.addEventListener('message', (event) => {
        const data = event.data;
        
        switch (data.action) {
          case 'openUI':
            this.openUI(data);
            break;
          case 'closeUI':
            this.closeUI();
            break;
          case 'updateMarket':
            this.updateMarketData(data.marketData);
            break;
          case 'updateBitcoin':
            this.updateBitcoinAmount(data.amount);
            break;
          case 'updateInventory':
            this.updateInventory(data.inventory);
            break;
        }
      });
    },
    
    setupKeyboardShortcuts() {
      document.addEventListener('keydown', (e) => {
        if (!this.isVisible) return;
        
        if (e.key === 'Escape') {
          if (this.showModal) {
            this.closeModal();
          } else {
            this.closeUI();
          }
        }
        
        if (e.key === 'Tab') {
          e.preventDefault();
          this.switchTab(this.currentTab === 'market' ? 'inventory' : 'market');
        }
        
        if (e.ctrlKey && e.key === 'r') {
          e.preventDefault();
          this.refreshMarket();
        }
      });
    },
    
    openUI(data) {
      this.marketData = data.marketData || [];
      this.playerBitcoin = data.bitcoinAmount || 0;
      this.playerInventory = data.inventory || [];
      this.isVisible = true;
      this.filterItems();
    },
    
    closeUI() {
      this.isVisible = false;
      this.closeModal();
      
      // Send close event to client
      fetch('https://blackmarket/closeUI', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
      });
    },
    
    switchTab(tab) {
      this.currentTab = tab;
    },
    
    filterItems() {
      this.filteredItems = this.marketData.filter(item => {
        const matchesSearch = !this.searchQuery || 
          item.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
          item.description.toLowerCase().includes(this.searchQuery.toLowerCase());
        const matchesCategory = this.categoryFilter === 'all' || item.category === this.categoryFilter;
        const matchesRarity = this.rarityFilter === 'all' || item.rarity === this.rarityFilter;
        return matchesSearch && matchesCategory && matchesRarity;
      });
    },
    
    updateMarketData(marketData) {
      this.marketData = marketData;
      this.filterItems();
    },
    
    updateBitcoinAmount(amount) {
      this.playerBitcoin = amount;
    },
    
    updateInventory(inventory) {
      this.playerInventory = inventory;
    },
    
    getMaxAffordable(item) {
      return Math.floor(this.playerBitcoin / item.price);
    },
    
    hasInInventory(itemName) {
      return this.playerInventory.find(item => item.itemName === itemName && item.quantity > 0);
    },
    
    getSellPrice(itemName) {
      const marketItem = this.marketData.find(item => item.itemName === itemName);
      return marketItem ? marketItem.price * 0.85 : 0;
    },
    
    calculateItemValue(item) {
      const sellPrice = this.getSellPrice(item.itemName);
      return sellPrice * item.quantity;
    },
    
    buyItem(item) {
      const maxAffordable = this.getMaxAffordable(item);
      if (maxAffordable < 1) {
        this.showNotification('Insufficient Bitcoin!', 'error');
        return;
      }
      
      this.currentTransaction = {
        type: 'buy',
        item: item,
        price: item.price,
        maxQuantity: maxAffordable,
        totalValue: 0
      };
      
      this.modalTitle = `Buy ${item.name}`;
      this.transactionQuantity = 1;
      this.updateTotalCost();
      this.showModal = true;
    },
    
    sellItem(item) {
      const inventoryItem = this.hasInInventory(item.itemName);
      if (!inventoryItem) {
        this.showNotification('Item not found in inventory!', 'error');
        return;
      }
      
      const sellPrice = this.getSellPrice(item.itemName);
      
      this.currentTransaction = {
        type: 'sell',
        item: item,
        price: sellPrice,
        maxQuantity: inventoryItem.quantity,
        totalValue: sellPrice * inventoryItem.quantity
      };
      
      this.modalTitle = `Sell ${item.name}`;
      this.transactionQuantity = 1;
      this.updateTotalCost();
      this.showModal = true;
    },
    
    sellInventoryItem(item) {
      const marketItem = this.marketData.find(m => m.itemName === item.itemName);
      if (marketItem) {
        this.sellItem(marketItem);
      }
    },
    
    updateTotalCost() {
      if (this.currentTransaction.type === 'buy') {
        this.totalCost = this.currentTransaction.price * this.transactionQuantity;
      } else {
        this.totalCost = this.currentTransaction.price * this.transactionQuantity;
      }
    },
    
    confirmTransaction() {
      if (!this.currentTransaction.item || !this.transactionQuantity) {
        this.showNotification('Invalid transaction data!', 'error');
        return;
      }
      
      const quantity = parseInt(this.transactionQuantity);
      if (quantity < 1 || quantity > this.currentTransaction.maxQuantity) {
        this.showNotification('Invalid quantity!', 'error');
        return;
      }
      
      if (this.currentTransaction.type === 'buy') {
        fetch('https://blackmarket/buyItem', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            item: this.currentTransaction.item.itemName,
            quantity: quantity,
            price: this.currentTransaction.item.price
          })
        });
      } else {
        fetch('https://blackmarket/sellItem', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            item: this.currentTransaction.item.itemName,
            quantity: quantity
          })
        });
      }
      
      this.closeModal();
    },
    
    closeModal() {
      this.showModal = false;
      this.currentTransaction = {};
      this.transactionQuantity = 1;
      this.totalCost = 0;
    },
    
    refreshMarket() {
      fetch('https://blackmarket/refreshMarket', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
      });
    },
    
    showNotification(message, type = 'info') {
      this.notification = {
        show: true,
        message: message,
        type: type
      };
      
      setTimeout(() => {
        this.notification.show = false;
      }, 3000);
    },
    
    formatBitcoin(amount) {
      return parseFloat(amount).toFixed(8);
    }
  }
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Rajdhani:wght@300;400;500;600;700&display=swap');

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.black-market-container {
  font-family: 'Rajdhani', sans-serif;
  background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 50%, #0a0a0a 100%);
  color: #ffffff;
  overflow: hidden;
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  z-index: 1000;
}

.matrix-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y="20" font-family="monospace" font-size="10" fill="rgba(0,255,0,0.1)">0101010101</text><text y="40" font-family="monospace" font-size="10" fill="rgba(0,255,0,0.1)">1010101010</text><text y="60" font-family="monospace" font-size="10" fill="rgba(0,255,0,0.1)">0101010101</text><text y="80" font-family="monospace" font-size="10" fill="rgba(0,255,0,0.1)">1010101010</text></svg>') repeat;
  opacity: 0.1;
  animation: matrix-scroll 20s linear infinite;
}

@keyframes matrix-scroll {
  0% { transform: translateY(0); }
  100% { transform: translateY(-100px); }
}

.container {
  width: 100%;
  height: 100%;
  display: flex;
  position: relative;
  background: 
    radial-gradient(circle at 20% 20%, rgba(255, 0, 0, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 80% 80%, rgba(0, 255, 0, 0.1) 0%, transparent 50%),
    linear-gradient(135deg, #000000 0%, #1a0a0a 100%);
}

.sidebar {
  width: 300px;
  background: linear-gradient(180deg, rgba(20, 20, 20, 0.9) 0%, rgba(10, 10, 10, 0.9) 100%);
  border-right: 2px solid #ff0040;
  backdrop-filter: blur(10px);
  padding: 20px;
  overflow-y: auto;
}

.logo {
  text-align: center;
  margin-bottom: 30px;
}

.logo h1 {
  font-family: 'Orbitron', monospace;
  font-size: 24px;
  color: #ff0040;
  text-shadow: 0 0 20px #ff0040;
  margin-bottom: 5px;
}

.logo p {
  font-size: 12px;
  color: #888;
  letter-spacing: 2px;
}

.bitcoin-wallet {
  background: linear-gradient(135deg, #ff8c00 0%, #ff6b00 100%);
  padding: 15px;
  border-radius: 10px;
  margin-bottom: 20px;
  border: 1px solid #ff8c00;
  box-shadow: 0 0 20px rgba(255, 140, 0, 0.3);
}

.bitcoin-wallet h3 {
  font-family: 'Orbitron', monospace;
  font-size: 14px;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.bitcoin-amount {
  font-size: 20px;
  font-weight: 700;
  color: #fff;
}

.nav-tabs {
  display: flex;
  margin-bottom: 20px;
  border-bottom: 1px solid #333;
}

.nav-tab {
  flex: 1;
  padding: 10px;
  background: transparent;
  border: none;
  color: #888;
  cursor: pointer;
  font-family: 'Rajdhani', sans-serif;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.nav-tab.active {
  color: #ff0040;
  border-bottom: 2px solid #ff0040;
}

.filters {
  margin-bottom: 20px;
}

.filter-group {
  margin-bottom: 15px;
}

.filter-group label {
  display: block;
  margin-bottom: 5px;
  font-size: 12px;
  color: #aaa;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.filter-select {
  width: 100%;
  padding: 8px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid #333;
  border-radius: 5px;
  color: #fff;
  font-family: 'Rajdhani', sans-serif;
}

.search-box {
  width: 100%;
  padding: 10px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid #333;
  border-radius: 5px;
  color: #fff;
  font-family: 'Rajdhani', sans-serif;
  margin-bottom: 20px;
}

.search-box::placeholder {
  color: #666;
}

.main-content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.header h2 {
  font-family: 'Orbitron', monospace;
  font-size: 28px;
  color: #00ff00;
  text-shadow: 0 0 20px #00ff00;
}

.market-status {
  display: flex;
  gap: 20px;
  align-items: center;
}

.status-indicator {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 12px;
}

.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #00ff00;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.3; }
}

.items-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.item-card {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 15px;
  padding: 20px;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  cursor: pointer;
}

.item-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 30px rgba(255, 0, 64, 0.3);
  border-color: #ff0040;
}

.item-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, transparent, #ff0040, transparent);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.item-card:hover::before {
  opacity: 1;
}

.item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.item-name {
  font-family: 'Orbitron', monospace;
  font-size: 16px;
  color: #fff;
  font-weight: 700;
}

.item-rarity {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 10px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.rarity-common { background: #666; }
.rarity-uncommon { background: #4caf50; }
.rarity-rare { background: #2196f3; }
.rarity-epic { background: #9c27b0; }
.rarity-legendary { background: #ff9800; }

.item-image {
  width: 80px;
  height: 80px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  margin: 0 auto 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40px;
  border: 2px solid rgba(255, 255, 255, 0.2);
}

.item-description {
  font-size: 11px;
  color: #aaa;
  margin-bottom: 10px;
  text-align: center;
  font-style: italic;
}

.item-stats {
  display: flex;
  justify-content: space-between;
  margin-bottom: 15px;
  font-size: 12px;
}

.stat {
  text-align: center;
}

.stat-value {
  font-weight: 700;
  font-size: 14px;
  color: #00ff00;
}

.stat-label {
  color: #888;
  margin-top: 2px;
}

.price-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.price {
  font-family: 'Orbitron', monospace;
  font-size: 18px;
  font-weight: 700;
  color: #ff8c00;
  display: flex;
  align-items: center;
  gap: 5px;
}

.price-change {
  font-size: 10px;
  padding: 2px 6px;
  border-radius: 8px;
  font-weight: 600;
}

.price-up {
  background: rgba(0, 255, 0, 0.2);
  color: #00ff00;
}

.price-down {
  background: rgba(255, 0, 0, 0.2);
  color: #ff0040;
}

.action-buttons {
  display: flex;
  gap: 10px;
}

.btn {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 8px;
  font-family: 'Rajdhani', sans-serif;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
}

.btn-buy {
  background: linear-gradient(135deg, #00ff00 0%, #00cc00 100%);
  color: #000;
}

.btn-buy:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 255, 0, 0.4);
}

.btn-sell {
  background: linear-gradient(135deg, #ff0040 0%, #cc0033 100%);
  color: #fff;
}

.btn-sell:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(255, 0, 64, 0.4);
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.inventory-section {
  margin-top: 30px;
}

.inventory-section h3 {
  font-family: 'Orbitron', monospace;
  color: #ff0040;
  margin-bottom: 20px;
  font-size: 20px;
}

.inventory-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 15px;
}

.inventory-item {
  background: rgba(255, 0, 64, 0.1);
  border: 1px solid rgba(255, 0, 64, 0.3);
  border-radius: 10px;
  padding: 15px;
  text-align: center;
}

.inventory-item h4 {
  color: #fff;
  margin-bottom: 10px;
  font-size: 14px;
}

.inventory-quantity {
  color: #00ff00;
  font-weight: 700;
  margin-bottom: 10px;
}

.inventory-value {
  color: #ff8c00;
  font-weight: 600;
  margin-bottom: 10px;
  font-size: 12px;
}

.modal {
  display: flex;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);
  z-index: 1000;
  backdrop-filter: blur(5px);
  align-items: center;
  justify-content: center;
}

.modal-content {
  background: linear-gradient(135deg, rgba(20, 20, 20, 0.95) 0%, rgba(10, 10, 10, 0.95) 100%);
  border: 2px solid #ff0040;
  border-radius: 15px;
  padding: 30px;
  width: 90%;
  max-width: 500px;
  backdrop-filter: blur(10px);
  position: relative;
}

.modal h3 {
  font-family: 'Orbitron', monospace;
  color: #ff0040;
  margin-bottom: 20px;
  text-align: center;
}

.transaction-details {
  margin-bottom: 15px;
}

.transaction-details p {
  margin: 5px 0;
  font-size: 14px;
}

.quantity-input {
  width: 100%;
  padding: 10px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid #333;
  border-radius: 5px;
  color: #fff;
  font-family: 'Rajdhani', sans-serif;
  margin-bottom: 20px;
}

.total-display {
  margin-top: 10px;
  padding: 10px;
  background: rgba(255, 140, 0, 0.1);
  border-radius: 5px;
  border: 1px solid rgba(255, 140, 0, 0.3);
  margin-bottom: 20px;
}

.modal-buttons {
  display: flex;
  gap: 10px;
  justify-content: center;
}

.close {
  position: absolute;
  top: 10px;
  right: 15px;
  font-size: 24px;
  cursor: pointer;
  color: #ff0040;
}

.notification {
  position: fixed;
  top: 20px;
  right: 20px;
  padding: 15px 20px;
  border-radius: 10px;
  color: #fff;
  font-weight: 600;
  z-index: 1001;
  animation: slideIn 0.3s ease;
}

@keyframes slideIn {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}

.notification.success {
  background: linear-gradient(135deg, #00ff00 0%, #00cc00 100%);
}

.notification.error {
  background: linear-gradient(135deg, #ff0040 0%, #cc0033 100%);
}

.notification.info {
  background: linear-gradient(135deg, #0066ff 0%, #0044cc 100%);
}

::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
}

::-webkit-scrollbar-thumb {
  background: #ff0040;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #ff0050;
}