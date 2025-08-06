import './Dashboard.css';

function Dashboard({ user, onLogout }) {
  return (
    <div className="dashboard-container">
      <nav className="navbar">
        <h2>Dashboard</h2>
        <button onClick={onLogout} className="logout-btn">
          Logout
        </button>
      </nav>
      
      <div className="dashboard-content">
        <div className="user-card">
          <h1>Welcome, {user?.name}!</h1>
          {user?.picture && (
            <img 
              src={user.picture} 
              alt={user.name} 
              className="user-avatar"
            />
          )}
          <div className="user-info">
            <p><strong>Email:</strong> {user?.email}</p>
            <p><strong>Provider:</strong> {user?.provider || 'Google'}</p>
            <p><strong>Member Since:</strong> {new Date(user?.createdAt).toLocaleDateString()}</p>
            <p><strong>Last Login:</strong> {new Date(user?.lastLogin).toLocaleString()}</p>
          </div>
        </div>
        
        <div className="features-section">
          <h2>Features</h2>
          <div className="feature-grid">
            <div className="feature-card">
              <h3>Secure Authentication</h3>
              <p>OAuth 2.0 with Google for secure login</p>
            </div>
            <div className="feature-card">
              <h3>JWT Tokens</h3>
              <p>Secure token-based authentication</p>
            </div>
            <div className="feature-card">
              <h3>User Profile</h3>
              <p>Manage your profile information</p>
            </div>
            <div className="feature-card">
              <h3>Session Management</h3>
              <p>Secure session handling</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;