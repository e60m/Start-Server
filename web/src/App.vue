<template>
  <div class="black-market-app">
    <!-- Header -->
    <div class="app-header">
      <div class="header-left">
        <div class="app-icon">
          <i class="fas fa-user-secret"></i>
        </div>
        <div class="app-title">
          <h1>BLACK MARKET</h1>
          <p>Secure • Anonymous • Untraceable</p>
        </div>
      </div>
      <div class="header-right">
        <div class="bitcoin-wallet">
          <i class="fab fa-bitcoin"></i>
          <span>{{ formatBitcoin(playerBitcoin) }} BTC</span>
        </div>
        <div class="market-status">
          <div class="status-dot online"></div>
          <span>Market Online</span>
        </div>
      </div>
    </div>

    <!-- Navigation -->
    <div class="app-nav">
      <button 
        class="nav-btn" 
        :class="{ active: activeTab === 'market' }"
        @click="setActiveTab('market')"
      >
        <i class="fas fa-store"></i>
        <span>Market</span>
      </button>
      <button 
        class="nav-btn" 
        :class="{ active: activeTab === 'inventory' }"
        @click="setActiveTab('inventory')"
      >
        <i class="fas fa-boxes"></i>
        <span>Inventory</span>
      </button>
      <button 
        class="nav-btn" 
        :class="{ active: activeTab === 'transactions' }"
        @click="setActiveTab('transactions')"
      >
        <i class="fas fa-history"></i>
        <span>History</span>
      </button>
    </div>

    <!-- Content -->
    <div class="app-content">
      <!-- Market Tab -->
      <div v-if="activeTab === 'market'" class="market-tab">
        <!-- Filters -->
        <div class="filters-section">
          <div class="search-container">
            <i class="fas fa-search"></i>
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Search items..."
              class="search-input"
              @input="filterItems"
            >
          </div>
          <div class="filter-selects">
            <select v-model="categoryFilter" @change="filterItems" class="filter-select">
              <option value="all">All Categories</option>
              <option value="weapon">Weapons</option>
              <option value="drug">Drugs</option>
              <option value="ammo">Ammunition</option>
              <option value="illegal">Illegal Items</option>
              <option value="stolen">Stolen Goods</option>
            </select>
            <select v-model="rarityFilter" @change="filterItems" class="filter-select">
              <option value="all">All Rarities</option>
              <option value="common">Common</option>
              <option value="uncommon">Uncommon</option>
              <option value="rare">Rare</option>
              <option value="epic">Epic</option>
              <option value="legendary">Legendary</option>
            </select>
          </div>
        </div>

        <!-- Market Items -->
        <div class="market-grid">
          <div 
            v-for="item in filteredItems" 
            :key="item.itemName"
            class="market-item"
            :class="'rarity-' + item.rarity"
          >
            <div class="item-image">
              <span class="item-emoji">{{ item.emoji }}</span>
              <div class="item-rarity">{{ item.rarity }}</div>
            </div>
            
            <div class="item-info">
              <h3 class="item-name">{{ item.name }}</h3>
              <p class="item-description">{{ item.description }}</p>
              
              <div class="item-stats">
                <div class="stat">
                  <span class="stat-label">Demand</span>
                  <div class="stat-bar">
                    <div class="stat-fill" :style="{ width: item.demand + '%' }"></div>
                  </div>
                  <span class="stat-value">{{ Math.round(item.demand) }}%</span>
                </div>
                <div class="stat">
                  <span class="stat-label">Supply</span>
                  <div class="stat-bar">
                    <div class="stat-fill supply" :style="{ width: (item.supply / 2) + '%' }"></div>
                  </div>
                  <span class="stat-value">{{ Math.round(item.supply) }}</span>
                </div>
              </div>
              
              <div class="item-price">
                <div class="price-main">
                  <i class="fab fa-bitcoin"></i>
                  <span>{{ formatBitcoin(item.price) }}</span>
                </div>
                <div class="price-change" :class="item.priceChange >= 0 ? 'positive' : 'negative'">
                  <i class="fas" :class="item.priceChange >= 0 ? 'fa-arrow-up' : 'fa-arrow-down'"></i>
                  {{ Math.abs(item.priceChange).toFixed(1) }}%
                </div>
              </div>
            </div>
            
            <div class="item-actions">
              <button 
                class="action-btn buy-btn"
                :disabled="getMaxAffordable(item) < 1"
                @click="buyItem(item)"
              >
                <i class="fas fa-shopping-cart"></i>
                Buy ({{ getMaxAffordable(item) }})
              </button>
              <button 
                class="action-btn sell-btn"
                :disabled="!hasInInventory(item.itemName)"
                @click="sellItem(item)"
              >
                <i class="fas fa-dollar-sign"></i>
                Sell
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Inventory Tab -->
      <div v-if="activeTab === 'inventory'" class="inventory-tab">
        <div class="inventory-header">
          <h2>Your Inventory</h2>
          <div class="inventory-value">
            <span>Total Value: </span>
            <i class="fab fa-bitcoin"></i>
            <span>{{ formatBitcoin(getTotalInventoryValue()) }}</span>
          </div>
        </div>
        
        <div class="inventory-grid">
          <div 
            v-for="item in playerInventory" 
            :key="item.itemName"
            class="inventory-item"
          >
            <div class="item-image">
              <span class="item-emoji">{{ getItemEmoji(item.itemName) }}</span>
              <div class="item-quantity">{{ item.quantity }}</div>
            </div>
            
            <div class="item-info">
              <h3 class="item-name">{{ item.name }}</h3>
              <div class="item-value">
                <span>Value: </span>
                <i class="fab fa-bitcoin"></i>
                <span>{{ formatBitcoin(calculateItemValue(item)) }}</span>
              </div>
              <div class="item-unit-price">
                <span>Unit Price: </span>
                <i class="fab fa-bitcoin"></i>
                <span>{{ formatBitcoin(getSellPrice(item.itemName)) }}</span>
              </div>
            </div>
            
            <div class="item-actions">
              <button 
                class="action-btn sell-btn"
                @click="sellInventoryItem(item)"
              >
                <i class="fas fa-dollar-sign"></i>
                Sell
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Transactions Tab -->
      <div v-if="activeTab === 'transactions'" class="transactions-tab">
        <div class="transactions-header">
          <h2>Transaction History</h2>
          <button class="refresh-btn" @click="refreshTransactions">
            <i class="fas fa-sync-alt"></i>
            Refresh
          </button>
        </div>
        
        <div class="transactions-list">
          <div 
            v-for="transaction in recentTransactions" 
            :key="transaction.id"
            class="transaction-item"
            :class="transaction.type"
          >
            <div class="transaction-icon">
              <i class="fas" :class="transaction.type === 'buy' ? 'fa-shopping-cart' : 'fa-dollar-sign'"></i>
            </div>
            
            <div class="transaction-info">
              <h4>{{ transaction.type === 'buy' ? 'Purchased' : 'Sold' }} {{ transaction.itemName }}</h4>
              <p>{{ transaction.quantity }} units</p>
              <span class="transaction-time">{{ formatDate(transaction.timestamp) }}</span>
            </div>
            
            <div class="transaction-amount" :class="transaction.type">
              <i class="fab fa-bitcoin"></i>
              <span>{{ transaction.type === 'buy' ? '-' : '+' }}{{ formatBitcoin(transaction.totalAmount) }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Transaction Modal -->
    <div v-if="showModal" class="modal-overlay" @click="closeModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>{{ modalTitle }}</h3>
          <button class="close-btn" @click="closeModal">
            <i class="fas fa-times"></i>
          </button>
        </div>
        
        <div class="modal-body">
          <div class="transaction-preview">
            <div class="item-preview">
              <span class="item-emoji">{{ currentTransaction.item?.emoji }}</span>
              <div class="item-details">
                <h4>{{ currentTransaction.item?.name }}</h4>
                <p>{{ currentTransaction.item?.description }}</p>
              </div>
            </div>
            
            <div class="transaction-details">
              <div class="detail-row">
                <span>{{ currentTransaction.type === 'buy' ? 'Price' : 'Sell Price' }}:</span>
                <span>
                  <i class="fab fa-bitcoin"></i>
                  {{ formatBitcoin(currentTransaction.price) }}
                </span>
              </div>
              
              <div class="detail-row">
                <span>{{ currentTransaction.type === 'buy' ? 'Available' : 'You Have' }}:</span>
                <span>
                  {{ currentTransaction.type === 'buy' ? 
                     '₿ ' + formatBitcoin(playerBitcoin) : 
                     currentTransaction.maxQuantity + ' units' }}
                </span>
              </div>
              
              <div class="detail-row">
                <span>Max Quantity:</span>
                <span>{{ currentTransaction.maxQuantity }}</span>
              </div>
            </div>
            
            <div class="quantity-input-container">
              <label>Quantity:</label>
              <input 
                type="number" 
                v-model="transactionQuantity"
                :min="1"
                :max="currentTransaction.maxQuantity"
                class="quantity-input"
                @input="updateTotalCost"
              >
            </div>
            
            <div class="total-cost">
              <span>{{ currentTransaction.type === 'buy' ? 'Total Cost' : 'Total Earning' }}:</span>
              <span class="total-amount">
                <i class="fab fa-bitcoin"></i>
                {{ formatBitcoin(totalCost) }}
              </span>
            </div>
          </div>
        </div>
        
        <div class="modal-actions">
          <button class="modal-btn cancel-btn" @click="closeModal">
            <i class="fas fa-times"></i>
            Cancel
          </button>
          <button class="modal-btn confirm-btn" @click="confirmTransaction">
            <i class="fas fa-check"></i>
            Confirm {{ currentTransaction.type === 'buy' ? 'Purchase' : 'Sale' }}
          </button>
        </div>
      </div>
    </div>

    <!-- Notifications -->
    <div class="notifications">
      <div 
        v-for="notification in notifications" 
        :key="notification.id"
        class="notification"
        :class="notification.type"
      >
        <i class="fas" :class="getNotificationIcon(notification.type)"></i>
        <span>{{ notification.message }}</span>
        <button @click="removeNotification(notification.id)" class="notification-close">
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BlackMarketApp',
  data() {
    return {
      activeTab: 'market',
      searchQuery: '',
      categoryFilter: 'all',
      rarityFilter: 'all',
      
      // Market data
      marketData: [],
      filteredItems: [],
      playerBitcoin: 0,
      playerInventory: [],
      recentTransactions: [],
      
      // Transaction modal
      showModal: false,
      modalTitle: '',
      currentTransaction: {},
      transactionQuantity: 1,
      totalCost: 0,
      
      // Notifications
      notifications: [],
      notificationId: 0
    }
  },
  
  mounted() {
    this.setupEventListeners();
    this.loadInitialData();
  },
  
  methods: {
    setupEventListeners() {
      // Listen for NUI messages
      window.addEventListener('message', (event) => {
        const data = event.data;
        
        switch (data.action) {
          case 'updateMarketData':
            this.updateMarketData(data.marketData);
            break;
          case 'updateBitcoin':
            this.updateBitcoinAmount(data.amount);
            break;
          case 'updateInventory':
            this.updateInventory(data.inventory);
            break;
          case 'updateTransactions':
            this.updateTransactions(data.transactions);
            break;
          case 'showNotification':
            this.showNotification(data.message, data.type);
            break;
        }
      });
    },
    
    loadInitialData() {
      // Request initial data from server
      this.sendNUIMessage('blackmarket:requestData', {});
    },
    
    sendNUIMessage(event, data) {
      fetch(`https://blackmarket/${event}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });
    },
    
    setActiveTab(tab) {
      this.activeTab = tab;
      
      // Load tab-specific data
      if (tab === 'transactions') {
        this.loadTransactionHistory();
      }
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
    
    updateTransactions(transactions) {
      this.recentTransactions = transactions;
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
    
    getTotalInventoryValue() {
      return this.playerInventory.reduce((total, item) => {
        return total + this.calculateItemValue(item);
      }, 0);
    },
    
    getItemEmoji(itemName) {
      const marketItem = this.marketData.find(item => item.itemName === itemName);
      return marketItem ? marketItem.emoji : '📦';
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
        maxQuantity: maxAffordable
      };
      
      this.modalTitle = `Purchase ${item.name}`;
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
        maxQuantity: inventoryItem.quantity
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
      this.totalCost = this.currentTransaction.price * this.transactionQuantity;
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
        this.sendNUIMessage('blackmarket:buyItem', {
          item: this.currentTransaction.item.itemName,
          quantity: quantity,
          price: this.currentTransaction.item.price
        });
      } else {
        this.sendNUIMessage('blackmarket:sellItem', {
          item: this.currentTransaction.item.itemName,
          quantity: quantity
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
    
    loadTransactionHistory() {
      this.sendNUIMessage('blackmarket:getTransactions', {});
    },
    
    refreshTransactions() {
      this.loadTransactionHistory();
    },
    
    showNotification(message, type = 'info') {
      const notification = {
        id: ++this.notificationId,
        message: message,
        type: type
      };
      
      this.notifications.push(notification);
      
      // Auto remove after 5 seconds
      setTimeout(() => {
        this.removeNotification(notification.id);
      }, 5000);
    },
    
    removeNotification(id) {
      this.notifications = this.notifications.filter(n => n.id !== id);
    },
    
    getNotificationIcon(type) {
      switch (type) {
        case 'success': return 'fa-check-circle';
        case 'error': return 'fa-exclamation-circle';
        case 'warning': return 'fa-exclamation-triangle';
        default: return 'fa-info-circle';
      }
    },
    
    formatBitcoin(amount) {
      return parseFloat(amount).toFixed(8);
    },
    
    formatDate(timestamp) {
      const date = new Date(timestamp * 1000);
      return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
    }
  }
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Rajdhani:wght@300;400;500;600;700&display=swap');

.black-market-app {
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 50%, #0a0a0a 100%);
  color: #ffffff;
  font-family: 'Rajdhani', sans-serif;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

/* Header */
.app-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  background: linear-gradient(135deg, rgba(255, 0, 64, 0.1) 0%, rgba(0, 0, 0, 0.2) 100%);
  border-bottom: 2px solid #ff0040;
  backdrop-filter: blur(10px);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 15px;
}

.app-icon {
  width: 50px;
  height: 50px;
  background: linear-gradient(135deg, #ff0040 0%, #cc0033 100%);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
  box-shadow: 0 0 20px rgba(255, 0, 64, 0.5);
}

.app-title h1 {
  font-family: 'Orbitron', monospace;
  font-size: 24px;
  margin: 0;
  color: #ff0040;
  text-shadow: 0 0 10px #ff0040;
}

.app-title p {
  font-size: 12px;
  margin: 0;
  color: #888;
  letter-spacing: 1px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.bitcoin-wallet {
  display: flex;
  align-items: center;
  gap: 8px;
  background: linear-gradient(135deg, #ff8c00 0%, #ff6b00 100%);
  padding: 10px 15px;
  border-radius: 25px;
  font-weight: 700;
  font-size: 16px;
  box-shadow: 0 0 15px rgba(255, 140, 0, 0.3);
}

.market-status {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
}

.status-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  animation: pulse 2s ease-in-out infinite;
}

.status-dot.online {
  background: #00ff00;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.3; }
}

/* Navigation */
.app-nav {
  display: flex;
  background: rgba(0, 0, 0, 0.3);
  border-bottom: 1px solid #333;
}

.nav-btn {
  flex: 1;
  padding: 15px;
  background: transparent;
  border: none;
  color: #888;
  cursor: pointer;
  font-family: 'Rajdhani', sans-serif;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.nav-btn:hover {
  background: rgba(255, 0, 64, 0.1);
  color: #ff0040;
}

.nav-btn.active {
  background: rgba(255, 0, 64, 0.2);
  color: #ff0040;
  border-bottom: 2px solid #ff0040;
}

/* Content */
.app-content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
}

/* Market Tab */
.filters-section {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
  align-items: center;
}

.search-container {
  position: relative;
  flex: 1;
}

.search-container i {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  color: #666;
}

.search-input {
  width: 100%;
  padding: 12px 12px 12px 45px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid #333;
  border-radius: 8px;
  color: #fff;
  font-family: 'Rajdhani', sans-serif;
  font-size: 14px;
}

.search-input::placeholder {
  color: #666;
}

.filter-selects {
  display: flex;
  gap: 10px;
}

.filter-select {
  padding: 12px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid #333;
  border-radius: 8px;
  color: #fff;
  font-family: 'Rajdhani', sans-serif;
  font-size: 14px;
  min-width: 120px;
}

.market-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 20px;
}

.market-item {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(0, 0, 0, 0.3) 100%);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 15px;
  padding: 20px;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  position: relative;
}

.market-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 30px rgba(255, 0, 64, 0.3);
  border-color: #ff0040;
}

.market-item.rarity-common { border-left: 4px solid #666; }
.market-item.rarity-uncommon { border-left: 4px solid #4caf50; }
.market-item.rarity-rare { border-left: 4px solid #2196f3; }
.market-item.rarity-epic { border-left: 4px solid #9c27b0; }
.market-item.rarity-legendary { border-left: 4px solid #ff9800; }

.item-image {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 15px;
}

.item-emoji {
  font-size: 48px;
  filter: drop-shadow(0 0 10px rgba(255, 255, 255, 0.3));
}

.item-rarity {
  padding: 4px 8px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  font-size: 10px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.item-info {
  margin-bottom: 15px;
}

.item-name {
  font-family: 'Orbitron', monospace;
  font-size: 18px;
  font-weight: 700;
  margin: 0 0 8px 0;
  color: #fff;
}

.item-description {
  font-size: 12px;
  color: #aaa;
  margin: 0 0 15px 0;
  line-height: 1.4;
}

.item-stats {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 15px;
}

.stat {
  display: flex;
  align-items: center;
  gap: 10px;
}

.stat-label {
  font-size: 12px;
  color: #888;
  min-width: 50px;
}

.stat-bar {
  flex: 1;
  height: 6px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
  overflow: hidden;
}

.stat-fill {
  height: 100%;
  background: linear-gradient(90deg, #ff0040 0%, #ff6b00 100%);
  transition: width 0.3s ease;
}

.stat-fill.supply {
  background: linear-gradient(90deg, #00ff00 0%, #00cc00 100%);
}

.stat-value {
  font-size: 12px;
  color: #fff;
  font-weight: 600;
  min-width: 35px;
  text-align: right;
}

.item-price {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 15px;
}

.price-main {
  display: flex;
  align-items: center;
  gap: 5px;
  font-family: 'Orbitron', monospace;
  font-size: 16px;
  font-weight: 700;
  color: #ff8c00;
}

.price-change {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  font-weight: 600;
  padding: 2px 6px;
  border-radius: 8px;
}

.price-change.positive {
  background: rgba(0, 255, 0, 0.2);
  color: #00ff00;
}

.price-change.negative {
  background: rgba(255, 0, 0, 0.2);
  color: #ff0040;
}

.item-actions {
  display: flex;
  gap: 10px;
}

.action-btn {
  flex: 1;
  padding: 10px;
  border: none;
  border-radius: 8px;
  font-family: 'Rajdhani', sans-serif;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
}

.buy-btn {
  background: linear-gradient(135deg, #00ff00 0%, #00cc00 100%);
  color: #000;
}

.buy-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 255, 0, 0.4);
}

.sell-btn {
  background: linear-gradient(135deg, #ff0040 0%, #cc0033 100%);
  color: #fff;
}

.sell-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(255, 0, 64, 0.4);
}

.action-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Inventory Tab */
.inventory-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.inventory-header h2 {
  font-family: 'Orbitron', monospace;
  color: #ff0040;
  margin: 0;
}

.inventory-value {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 18px;
  font-weight: 700;
  color: #ff8c00;
}

.inventory-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.inventory-item {
  background: linear-gradient(135deg, rgba(255, 0, 64, 0.1) 0%, rgba(0, 0, 0, 0.3) 100%);
  border: 1px solid rgba(255, 0, 64, 0.3);
  border-radius: 15px;
  padding: 20px;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.inventory-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 25px rgba(255, 0, 64, 0.2);
}

.inventory-item .item-image {
  position: relative;
  margin-bottom: 15px;
}

.inventory-item .item-quantity {
  position: absolute;
  top: -5px;
  right: -5px;
  background: #ff0040;
  color: white;
  border-radius: 50%;
  width: 25px;
  height: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: bold;
}

.inventory-item .item-value,
.inventory-item .item-unit-price {
  display: flex;
  align-items: center;
  gap: 5px;
  margin-bottom: 8px;
  font-size: 14px;
}

.inventory-item .item-value {
  color: #ff8c00;
  font-weight: 700;
}

.inventory-item .item-unit-price {
  color: #aaa;
  font-size: 12px;
}

/* Transactions Tab */
.transactions-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.transactions-header h2 {
  font-family: 'Orbitron', monospace;
  color: #ff0040;
  margin: 0;
}

.refresh-btn {
  background: linear-gradient(135deg, #0066ff 0%, #0044cc 100%);
  color: white;
  border: none;
  padding: 10px 15px;
  border-radius: 8px;
  cursor: pointer;
  font-family: 'Rajdhani', sans-serif;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: all 0.3s ease;
}

.refresh-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 102, 255, 0.4);
}

.transactions-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.transaction-item {
  display: flex;
  align-items: center;
  gap: 15px;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.05) 0%, rgba(0, 0, 0, 0.3) 100%);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  padding: 15px;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.transaction-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 20px rgba(255, 255, 255, 0.1);
}

.transaction-item.buy {
  border-left: 4px solid #00ff00;
}

.transaction-item.sell {
  border-left: 4px solid #ff0040;
}

.transaction-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
}

.transaction-item.buy .transaction-icon {
  background: rgba(0, 255, 0, 0.2);
  color: #00ff00;
}

.transaction-item.sell .transaction-icon {
  background: rgba(255, 0, 64, 0.2);
  color: #ff0040;
}

.transaction-info {
  flex: 1;
}

.transaction-info h4 {
  margin: 0 0 5px 0;
  font-size: 16px;
  color: #fff;
}

.transaction-info p {
  margin: 0 0 5px 0;
  font-size: 14px;
  color: #aaa;
}

.transaction-time {
  font-size: 12px;
  color: #666;
}

.transaction-amount {
  display: flex;
  align-items: center;
  gap: 5px;
  font-family: 'Orbitron', monospace;
  font-size: 16px;
  font-weight: 700;
}

.transaction-amount.buy {
  color: #ff0040;
}

.transaction-amount.sell {
  color: #00ff00;
}

/* Modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  backdrop-filter: blur(5px);
}

.modal-content {
  background: linear-gradient(135deg, rgba(20, 20, 20, 0.95) 0%, rgba(10, 10, 10, 0.95) 100%);
  border: 2px solid #ff0040;
  border-radius: 15px;
  width: 90%;
  max-width: 500px;
  max-height: 80vh;
  overflow-y: auto;
  backdrop-filter: blur(15px);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid rgba(255, 0, 64, 0.3);
}

.modal-header h3 {
  font-family: 'Orbitron', monospace;
  color: #ff0040;
  margin: 0;
}

.close-btn {
  background: none;
  border: none;
  color: #ff0040;
  font-size: 20px;
  cursor: pointer;
  padding: 5px;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.close-btn:hover {
  background: rgba(255, 0, 64, 0.2);
}

.modal-body {
  padding: 20px;
}

.transaction-preview {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.item-preview {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 15px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 10px;
}

.item-preview .item-emoji {
  font-size: 40px;
}

.item-details h4 {
  margin: 0 0 5px 0;
  color: #fff;
}

.item-details p {
  margin: 0;
  color: #aaa;
  font-size: 14px;
}

.transaction-details {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.detail-row {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.detail-row:last-child {
  border-bottom: none;
}

.quantity-input-container {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.quantity-input-container label {
  font-weight: 600;
  color: #fff;
}

.quantity-input {
  padding: 12px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid #333;
  border-radius: 8px;
  color: #fff;
  font-family: 'Rajdhani', sans-serif;
  font-size: 16px;
  text-align: center;
}

.total-cost {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  background: rgba(255, 140, 0, 0.1);
  border: 1px solid rgba(255, 140, 0, 0.3);
  border-radius: 10px;
  font-weight: 700;
}

.total-amount {
  display: flex;
  align-items: center;
  gap: 5px;
  font-family: 'Orbitron', monospace;
  font-size: 18px;
  color: #ff8c00;
}

.modal-actions {
  display: flex;
  gap: 10px;
  padding: 20px;
  border-top: 1px solid rgba(255, 0, 64, 0.3);
}

.modal-btn {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 8px;
  font-family: 'Rajdhani', sans-serif;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.cancel-btn {
  background: linear-gradient(135deg, #666 0%, #444 100%);
  color: #fff;
}

.cancel-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

.confirm-btn {
  background: linear-gradient(135deg, #00ff00 0%, #00cc00 100%);
  color: #000;
}

.confirm-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 255, 0, 0.4);
}

/* Notifications */
.notifications {
  position: fixed;
  top: 20px;
  right: 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  z-index: 1001;
}

.notification {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 15px;
  border-radius: 10px;
  color: #fff;
  font-weight: 600;
  min-width: 300px;
  backdrop-filter: blur(10px);
  animation: slideIn 0.3s ease;
  position: relative;
}

@keyframes slideIn {
  from { transform: translateX(100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}

.notification.success {
  background: linear-gradient(135deg, rgba(0, 255, 0, 0.9) 0%, rgba(0, 204, 0, 0.9) 100%);
  border: 1px solid #00ff00;
}

.notification.error {
  background: linear-gradient(135deg, rgba(255, 0, 64, 0.9) 0%, rgba(204, 0, 51, 0.9) 100%);
  border: 1px solid #ff0040;
}

.notification.warning {
  background: linear-gradient(135deg, rgba(255, 140, 0, 0.9) 0%, rgba(255, 107, 0, 0.9) 100%);
  border: 1px solid #ff8c00;
}

.notification.info {
  background: linear-gradient(135deg, rgba(0, 102, 255, 0.9) 0%, rgba(0, 68, 204, 0.9) 100%);
  border: 1px solid #0066ff;
}

.notification-close {
  position: absolute;
  top: 5px;
  right: 5px;
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  cursor: pointer;
  font-size: 12px;
  padding: 2px;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.notification-close:hover {
  color: #fff;
  background: rgba(255, 255, 255, 0.1);
}

/* Scrollbar */
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

/* Responsive */
@media (max-width: 768px) {
  .app-header {
    flex-direction: column;
    gap: 15px;
  }
  
  .filters-section {
    flex-direction: column;
    gap: 10px;
  }
  
  .filter-selects {
    flex-direction: column;
  }
  
  .market-grid,
  .inventory-grid {
    grid-template-columns: 1fr;
  }
  
  .modal-content {
    width: 95%;
    margin: 10px;
  }
  
  .notifications {
    left: 10px;
    right: 10px;
  }
  
  .notification {
    min-width: auto;
  }
}
</style>