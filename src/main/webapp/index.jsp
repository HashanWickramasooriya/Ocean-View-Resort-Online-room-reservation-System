<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ocean View Resort | Home</title>

<style>
:root{
  --bg:#E0F2FE;
  --primary:#0284C7;
  --sky:#22c1f0;
  --coral:#FB7185;

  --text:#0F172A;
  --muted:#475569;

  --panel: rgba(255,255,255,0.90);
  --panel2: rgba(255,255,255,0.98);
  --border: rgba(15,23,42,0.12);

  --shadow: 0 14px 34px rgba(15,23,42,0.12);
  --radius: 22px;
}

*{box-sizing:border-box}
body{
  margin:0;
  font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Arial;
  background:
    radial-gradient(900px 600px at 70% 10%, rgba(2,132,199,0.14), transparent 58%),
    radial-gradient(900px 650px at 20% 90%, rgba(16,185,129,0.10), transparent 60%),
    linear-gradient(180deg, var(--bg), #f8fbff);
  color:var(--text);
  min-height:100vh;
}

/* ✅ Top Nav */
.navbar{
  position:sticky;
  top:0;
  z-index:20;
  backdrop-filter: blur(14px);
  background: rgba(255,255,255,0.70);
  border-bottom:1px solid var(--border);
}
.nav-inner{
  max-width:1200px;
  margin:0 auto;
  padding:14px 18px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:14px;
}
.brand{
  display:flex;
  align-items:center;
  gap:12px;
  text-decoration:none;
  color:var(--text);
}
.logo{
  width:46px;height:46px;border-radius:16px;
  background: linear-gradient(135deg, var(--primary), var(--sky));
  box-shadow: 0 16px 34px rgba(2,132,199,0.18);
}
.brand h1{
  margin:0;
  font-size:16px;
  font-weight:950;
}
.brand p{
  margin:2px 0 0;
  font-size:12px;
  color:var(--muted);
  font-weight:800;
}
.links{
  display:flex;
  gap:10px;
  align-items:center;
  flex-wrap:wrap;
}
.links a{
  text-decoration:none;
  font-weight:900;
  color:var(--text);
  padding:10px 14px;
  border-radius:14px;
  border:1px solid rgba(15,23,42,0.10);
  background: rgba(255,255,255,0.70);
  transition: 0.2s ease;
}
.links a:hover{
  background: rgba(2,132,199,0.10);
  border-color: rgba(2,132,199,0.22);
}
.links .cta{
  color:#fff;
  border:none;
  background: linear-gradient(135deg, var(--primary), var(--sky));
  box-shadow: 0 12px 24px rgba(2,132,199,0.18);
}
.links .cta:hover{ filter:brightness(1.05); }

/* ✅ Container */
.container{
  max-width:1200px;
  margin:0 auto;
  padding:22px 18px 40px;
}

/* ✅ Hero */
.hero{
  border-radius: 28px;
  overflow:hidden;
  border:1px solid rgba(15,23,42,0.10);
  box-shadow: var(--shadow);
  background:
    linear-gradient(180deg, rgba(2,132,199,0.25), rgba(255,255,255,0.65)),
    radial-gradient(900px 650px at 70% 20%, rgba(34,193,240,0.22), transparent 60%),
    radial-gradient(900px 650px at 25% 85%, rgba(251,113,133,0.16), transparent 60%);
}
.hero-inner{
  padding:44px 26px;
  display:grid;
  grid-template-columns: 1.2fr 0.8fr;
  gap:18px;
  align-items:center;
}
.hero h2{
  margin:0;
  font-size:40px;
  line-height:1.1;
  font-weight:1000;
}
.hero p{
  margin:12px 0 0;
  color: rgba(15,23,42,0.80);
  font-weight:800;
  font-size:14px;
  max-width: 52ch;
}
.hero-actions{
  margin-top:18px;
  display:flex;
  gap:12px;
  flex-wrap:wrap;
}
.btn{
  display:inline-flex;
  align-items:center;
  justify-content:center;
  padding:12px 18px;
  border-radius:16px;
  font-weight:950;
  text-decoration:none;
  border:1px solid rgba(15,23,42,0.12);
  background: rgba(255,255,255,0.75);
  color: var(--text);
}
.btn:hover{
  background: rgba(2,132,199,0.10);
  border-color: rgba(2,132,199,0.22);
}
.btn-primary{
  border:none;
  color:#fff;
  background: linear-gradient(135deg, var(--primary), var(--sky));
  box-shadow: 0 14px 28px rgba(2,132,199,0.18);
}
.btn-primary:hover{ filter:brightness(1.05); }

.hero-card{
  border-radius:22px;
  background: rgba(255,255,255,0.82);
  border:1px solid rgba(15,23,42,0.10);
  box-shadow: 0 14px 30px rgba(15,23,42,0.10);
  padding:18px;
}
.hero-card h3{
  margin:0;
  font-size:14px;
  font-weight:950;
}
.hero-card .mini{
  margin-top:8px;
  display:grid;
  grid-template-columns: 1fr 1fr;
  gap:10px;
}
.mini-box{
  padding:12px;
  border-radius:18px;
  border:1px solid rgba(15,23,42,0.10);
  background: rgba(255,255,255,0.70);
}
.mini-box .t{
  font-size:12px;
  color:var(--muted);
  font-weight:900;
}
.mini-box .v{
  margin-top:4px;
  font-weight:1000;
}

/* ✅ Section */
.section{
  margin-top:22px;
}
.section-title{
  display:flex;
  justify-content:space-between;
  align-items:end;
  gap:12px;
  margin-bottom:12px;
}
.section-title h3{
  margin:0;
  font-size:18px;
  font-weight:1000;
}
.section-title p{
  margin:0;
  color:var(--muted);
  font-weight:800;
  font-size:13px;
}

/* ✅ Room Cards */
.grid{
  display:grid;
  grid-template-columns: repeat(3, 1fr);
  gap:14px;
}
.card{
  border-radius:22px;
  overflow:hidden;
  background: rgba(255,255,255,0.82);
  border:1px solid rgba(15,23,42,0.10);
  box-shadow: var(--shadow);
}
.card .img{
  height:150px;
  background:
    radial-gradient(500px 240px at 20% 30%, rgba(34,193,240,0.35), transparent 55%),
    radial-gradient(500px 240px at 85% 80%, rgba(251,113,133,0.20), transparent 60%),
    linear-gradient(135deg, rgba(2,132,199,0.25), rgba(255,255,255,0.75));
}
.card .body{
  padding:14px;
}
.card .name{
  margin:0;
  font-weight:1000;
  font-size:15px;
}
.card .meta{
  margin-top:6px;
  color:var(--muted);
  font-weight:800;
  font-size:13px;
}
.badges{
  margin-top:10px;
  display:flex;
  gap:8px;
  flex-wrap:wrap;
}
.badge{
  padding:6px 10px;
  border-radius:999px;
  font-size:12px;
  font-weight:950;
  border:1px solid rgba(15,23,42,0.10);
  background: rgba(2,132,199,0.10);
  color: rgba(2, 76, 129, 0.95);
}
.badge.coral{
  background: rgba(251,113,133,0.12);
  border-color: rgba(251,113,133,0.25);
  color: #b91c1c;
}
.card .footer{
  padding:14px;
  border-top:1px solid rgba(15,23,42,0.08);
  display:flex;
  justify-content:space-between;
  align-items:center;
  gap:10px;
}
.price{
  font-weight:1000;
}
.price span{
  color:var(--muted);
  font-weight:900;
  font-size:12px;
}
.card .footer a{
  padding:10px 14px;
  border-radius:14px;
  text-decoration:none;
  font-weight:950;
  color:#fff;
  background: linear-gradient(135deg, var(--primary), var(--sky));
}
.card .footer a:hover{ filter:brightness(1.05); }

/* ✅ Facilities */
.facilities{
  display:grid;
  grid-template-columns: repeat(4, 1fr);
  gap:12px;
}
.fac{
  padding:14px;
  border-radius:22px;
  border:1px solid rgba(15,23,42,0.10);
  background: rgba(255,255,255,0.82);
  box-shadow: var(--shadow);
}
.fac .title{
  font-weight:1000;
}
.fac .desc{
  margin-top:8px;
  color:var(--muted);
  font-weight:800;
  font-size:13px;
}

/* ✅ Testimonials */
.testimonials{
  display:grid;
  grid-template-columns: repeat(3, 1fr);
  gap:12px;
}
.quote{
  padding:14px;
  border-radius:22px;
  border:1px solid rgba(15,23,42,0.10);
  background: rgba(255,255,255,0.82);
  box-shadow: var(--shadow);
}
.quote p{
  margin:0;
  color: rgba(15,23,42,0.80);
  font-weight:850;
}
.quote .by{
  margin-top:10px;
  font-weight:1000;
  color: var(--text);
}
.quote .role{
  margin-top:2px;
  font-size:12px;
  font-weight:850;
  color: var(--muted);
}

/* ✅ Contact */
.contact{
  display:grid;
  grid-template-columns: 1fr 1fr;
  gap:14px;
}
.info, .map{
  border-radius:22px;
  border:1px solid rgba(15,23,42,0.10);
  background: rgba(255,255,255,0.82);
  box-shadow: var(--shadow);
  padding:16px;
}
.info h4{ margin:0; font-weight:1000; }
.info .line{ margin-top:10px; font-weight:850; color: var(--muted); }
.map .box{
  height:180px;
  border-radius:18px;
  border:1px dashed rgba(15,23,42,0.22);
  background: rgba(2,132,199,0.08);
  display:flex;
  align-items:center;
  justify-content:center;
  font-weight:950;
  color: rgba(2, 76, 129, 0.95);
}

/* Footer */
.footer{
  margin-top:24px;
  text-align:center;
  color:var(--muted);
  font-weight:800;
  font-size:13px;
}

/* Responsive */
@media (max-width: 1050px){
  .hero-inner{ grid-template-columns: 1fr; }
  .grid{ grid-template-columns: 1fr; }
  .facilities{ grid-template-columns: 1fr 1fr; }
  .testimonials{ grid-template-columns: 1fr; }
  .contact{ grid-template-columns: 1fr; }
}
</style>
</head>

<body>

<!-- ✅ Navbar -->
<header class="navbar">
  <div class="nav-inner">
    <a class="brand" href="<%=request.getContextPath()%>/index.jsp">
      <div class="logo"></div>
      <div>
        <h1>Ocean View Resort</h1>
        <p>Sea breeze • Comfort • Luxury</p>
      </div>
    </a>

    <nav class="links">
      <a href="#rooms">Rooms</a>
      <a href="#facilities">Facilities</a>
      <a href="#contact">Contact</a>

      <!-- Change these links based on your project -->
      <a href="<%=request.getContextPath()%>/login.jsp">Login</a>
      <a class="cta" href="<%=request.getContextPath()%>/guest/rooms">Book Now</a>
    </nav>
  </div>
</header>

<div class="container">

  <!-- ✅ Hero -->
  <section class="hero">
    <div class="hero-inner">

      <div>
        <h2>Relax by the ocean.<br>Stay with comfort.</h2>
        <p>
          Welcome to Ocean View Resort — beautiful rooms, friendly service,
          and a relaxing beach atmosphere for your perfect holiday.
        </p>

        <div class="hero-actions">
          <a class="btn btn-primary" href="<%=request.getContextPath()%>/guest/rooms">🏖 View Rooms</a>
          <a class="btn" href="#contact">📞 Contact Us</a>
        </div>
      </div>

      <div class="hero-card">
        <h3>Quick Info</h3>
        <div class="mini">
          <div class="mini-box">
            <div class="t">Check-in</div>
            <div class="v">2:00 PM</div>
          </div>
          <div class="mini-box">
            <div class="t">Check-out</div>
            <div class="v">12:00 PM</div>
          </div>
          <div class="mini-box">
            <div class="t">Support</div>
            <div class="v">24/7</div>
          </div>
          <div class="mini-box">
            <div class="t">Free</div>
            <div class="v">Wi-Fi</div>
          </div>
        </div>
      </div>

    </div>
  </section>

  <!-- ✅ Rooms -->
  <section class="section" id="rooms">
    <div class="section-title">
      <div>
        <h3>Popular Rooms</h3>
        <p>Choose your perfect stay — Standard to Villa</p>
      </div>
      <a class="btn" href="<%=request.getContextPath()%>/guest/rooms">See all →</a>
    </div>

    <div class="grid">
      <div class="card">
        <div class="img"></div>
        <div class="body">
          <p class="name">Standard Room</p>
          <div class="meta">Comfortable • Sea breeze • 2 Guests</div>
          <div class="badges">
            <span class="badge">AC</span>
            <span class="badge">Wi-Fi</span>
            <span class="badge coral">Breakfast</span>
          </div>
        </div>
        <div class="footer">
          <div class="price">LKR 12,500 <span>/ night</span></div>
          <a href="<%=request.getContextPath()%>/guest/rooms">Book</a>
        </div>
      </div>

      <div class="card">
        <div class="img"></div>
        <div class="body">
          <p class="name">Deluxe Room</p>
          <div class="meta">Balcony • Ocean view • 3 Guests</div>
          <div class="badges">
            <span class="badge">Balcony</span>
            <span class="badge">TV</span>
            <span class="badge coral">Pool Access</span>
          </div>
        </div>
        <div class="footer">
          <div class="price">LKR 18,900 <span>/ night</span></div>
          <a href="<%=request.getContextPath()%>/guest/rooms">Book</a>
        </div>
      </div>

      <div class="card">
        <div class="img"></div>
        <div class="body">
          <p class="name">Villa Suite</p>
          <div class="meta">Luxury • Private space • 4 Guests</div>
          <div class="badges">
            <span class="badge">Kitchen</span>
            <span class="badge">Jacuzzi</span>
            <span class="badge coral">Premium</span>
          </div>
        </div>
        <div class="footer">
          <div class="price">LKR 32,000 <span>/ night</span></div>
          <a href="<%=request.getContextPath()%>/guest/rooms">Book</a>
        </div>
      </div>
    </div>
  </section>

  <!-- ✅ Facilities -->
  <section class="section" id="facilities">
    <div class="section-title">
      <div>
        <h3>Facilities</h3>
        <p>Everything you need for a perfect holiday</p>
      </div>
    </div>

    <div class="facilities">
      <div class="fac">
        <div class="title">🏊 Swimming Pool</div>
        <div class="desc">Clean pool with relaxing view & seating.</div>
      </div>
      <div class="fac">
        <div class="title">🍽 Restaurant</div>
        <div class="desc">Fresh seafood & local cuisine daily.</div>
      </div>
      <div class="fac">
        <div class="title">🚗 Parking</div>
        <div class="desc">Secure parking available for guests.</div>
      </div>
      <div class="fac">
        <div class="title">📶 Free Wi-Fi</div>
        <div class="desc">High speed internet across the resort.</div>
      </div>
    </div>
  </section>

  <!-- ✅ Testimonials -->
  <section class="section">
    <div class="section-title">
      <div>
        <h3>Guest Reviews</h3>
        <p>What guests say about Ocean View Resort</p>
      </div>
    </div>

    <div class="testimonials">
      <div class="quote">
        <p>“Amazing view and clean rooms. Staff were very helpful!”</p>
        <div class="by">Kasun P.</div>
        <div class="role">Sri Lanka</div>
      </div>
      <div class="quote">
        <p>“Perfect for family stay. Great food and calm environment.”</p>
        <div class="by">Nimali S.</div>
        <div class="role">Colombo</div>
      </div>
      <div class="quote">
        <p>“Loved the deluxe balcony. Highly recommend this resort.”</p>
        <div class="by">Imesha R.</div>
        <div class="role">Galle</div>
      </div>
    </div>
  </section>

  <!-- ✅ Contact -->
  <section class="section" id="contact">
    <div class="section-title">
      <div>
        <h3>Contact</h3>
        <p>We are happy to help you anytime</p>
      </div>
    </div>

    <div class="contact">
      <div class="info">
        <h4>Ocean View Resort</h4>
        <div class="line">📍 Address: Beach Road, Sri Lanka</div>
        <div class="line">📞 Phone: +94 77 123 4567</div>
        <div class="line">✉ Email: oceanview@gmail.com</div>
        <div class="line">🕒 Open: 24/7 Reception</div>
      </div>

      <div class="map">
        <div class="box">Map Placeholder (Add Google Map iframe here)</div>
      </div>
    </div>
  </section>

  <div class="footer">
    © <%= java.time.Year.now() %> Ocean View Resort. All rights reserved.
  </div>

</div>

</body>
</html>
