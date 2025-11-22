<!DOCTYPE html>
<html lang="tr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ortaokul Derslerim - Gelişmiş LGS Platformu</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box;font-family:'Poppins',sans-serif;}
body{background:#f5f5f5;color:#333;line-height:1.6;}
nav{background:#4aa3df;padding:1rem;display:flex;flex-wrap:wrap;justify-content:center;gap:0.5rem;position:sticky;top:0;z-index:1000;}
nav a{color:white;font-weight:600;padding:0.5rem 1rem;border-radius:5px;transition:0.3s;}
nav a:hover{background:#3a8ac8;}
.hero{text-align:center;padding:3rem 1rem;background:white;box-shadow:0 2px 5px rgba(0,0,0,0.1);}
.hero h1{font-size:2.5rem;color:#4aa3df;margin-bottom:1rem;}
.hero p{font-size:1.2rem;margin-bottom:2rem;}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:1rem;padding:1rem;}
.card{background:#7ed957;color:white;padding:2rem;border-radius:10px;text-align:center;transition:0.3s;cursor:pointer;}
.card:hover{transform:translateY(-5px);box-shadow:0 5px 15px rgba(0,0,0,0.2);}
.lesson,.goal,.contact{max-width:900px;margin:2rem auto;background:white;padding:2rem;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1);}
.lesson h2,.goal h2,.contact h2{color:#4aa3df;margin-bottom:1rem;}
.quiz{margin:1rem 0;}
.quiz h4{margin-bottom:0.5rem;}
.quiz label{display:block;margin-bottom:0.3rem;cursor:pointer;padding:0.3rem;border-radius:5px;}
.quiz input:checked+span{font-weight:bold;}
.btn{display:inline-block;background:#4aa3df;color:white;padding:0.5rem 1rem;border-radius:5px;margin-top:0.5rem;cursor:pointer;transition:0.3s;}
.btn:hover{background:#3a8ac8;}
.pdf-btn{background:#ff6b6b;margin-top:1rem;}
.pdf-btn:hover{background:#e55a5a;}
.goal select,.goal input{width:100%;padding:0.5rem;margin-bottom:1rem;border:1px solid #ccc;border-radius:5px;}
.goal .goal-btn{background:#7ed957;}
.goal .goal-btn:hover{background:#6dc947;}
.contact input,.contact textarea{width:100%;padding:0.5rem;margin-bottom:1rem;border:1px solid #ccc;border-radius:5px;}
.contact button{background:#4aa3df;color:white;padding:0.5rem 1rem;border-radius:5px;cursor:pointer;}
.contact button:hover{background:#3a8ac8;}
.progress-container{background:#ddd;border-radius:10px;margin:1rem 0;height:20px;width:100%;}
.progress-bar{height:100%;background:#4aa3df;width:0%;border-radius:10px;}
.correct{background:#b7e4c7;}
.wrong{background:#f28b82;}
@media(max-width:600px){nav{flex-direction:column;align-items:center;}.cards{grid-template-columns:1fr;}}
</style>
</head>
<body>

<nav>
<a href="#home">Ana Sayfa</a>
<a href="#deneme">Deneme</a>
<a href="#goal">Hedef Belirleme</a>
<a href="#contact">İletişim</a>
</nav>

<section class="hero" id="home">
<h1>Ortaokul Derslerim - Gelişmiş LGS Platformu</h1>
<p>Denemeler LGS ağırlıklı puanlanır, ilerlemen kaydedilir ve hedefini görselleştirirsin!</p>
<div class="cards">
<div class="card" onclick="scrollToSection('deneme')">Deneme Çöz</div>
<div class="card" onclick="scrollToSection('goal')">Hedef Belirle</div>
<div class="card" onclick="scrollToSection('contact')">İletişim</div>
</div>
</section>

<section class="lesson" id="deneme">
<h2>Örnek Deneme</h2>
<p>Denemeler otomatik LGS ağırlıklı puanlanır ve cevaplar kaydedilir.</p>

<h3>Matematik (20 soru - 100 puan)</h3>
<div class="quiz">
<h4>Soru 1: 5 + 3 = ?</h4>
<label><input type="radio" name="mat1" value="true"><span>8</span></label>
<label><input type="radio" name="mat1" value="false"><span>7</span></label>
<label><input type="radio" name="mat1" value="false"><span>9</span></label>
</div>

<h3>Türkçe (20 soru - 100 puan)</h3>
<div class="quiz">
<h4>Soru 1: “Ev” kelimesinin çoğulu nedir?</h4>
<label><input type="radio" name="turk1" value="true"><span>Evler</span></label>
<label><input type="radio" name="turk1" value="false"><span>Evlerim</span></label>
<label><input type="radio" name="turk1" value="false"><span>Evlerimiz</span></label>
</div>

<h3>Fen (20 soru - 100 puan)</h3>
<div class="quiz">
<h4>Soru 1: Su kaç derecede donar?</h4>
<label><input type="radio" name="fen1" value="true"><span>0°C</span></label>
<label><input type="radio" name="fen1" value="false"><span>100°C</span></label>
<label><input type="radio" name="fen1" value="false"><span>50°C</span></label>
</div>

<div class="progress-container">
<div id="progress" class="progress-bar"></div>
</div>

<button class="btn" onclick="calculateDeneme()">Deneme Puanını Göster</button>
<p id="denemeResult"></p>
<button class="btn pdf-btn" onclick="downloadDenemePDF()">PDF İndir</button>
</section>

<section class="goal" id="goal">
<h2>Hedef Belirleme</h2>
<select id="schoolSelect">
<option value="Okul A" data-required="470">Okul A</option>
<option value="Okul B" data-required="450">Okul B</option>
<option value="Okul C" data-required="430">Okul C</option>
</select>
<input type="number" id="avgScore" placeholder="Ortalama puanınız">
<button class="btn goal-btn" onclick="showGoal()">Hedefi Göster</button>
<p id="goalResult"></p>
<div class="progress-container">
<div id="goalProgress" class="progress-bar"></div>
</div>
</section>

<section class="contact">
<h2>İletişim</h2>
<input type="text" id="contactName" placeholder="Adınız">
<input type="email" id="contactEmail" placeholder="E-posta">
<textarea id="contactMessage" placeholder="Mesajınız"></textarea>
<button onclick="sendMessage()">Gönder</button>
<p id="contactResult"></p>
</section>

<script>
// Scroll
function scrollToSection(id){document.getElementById(id).scrollIntoView({behavior:'smooth'});}

// Deneme Puanlama
function calculateDeneme(){
let total=0; let maxTotal=500; let progress=0;

// LGS ağırlıkları ve soru sayısı
const weights={Mat:100,Turk:100,Fen:100};
const counts={Mat:20,Turk:20,Fen:20};

// Matematik
let matChecked=document.querySelector('input[name="mat1"]:checked');
if(matChecked){total+= (matChecked.value==="true")?(weights.Mat/counts.Mat):0; matChecked.parentElement.classList.add(matChecked.value==="true"?'correct':'wrong');}

// Türkçe
let turkChecked=document.querySelector('input[name="turk1"]:checked');
if(turkChecked){total+= (turkChecked.value==="true")?(weights.Turk/counts.Turk):0; turkChecked.parentElement.classList.add(turkChecked.value==="true"?'correct':'wrong');}

// Fen
let fenChecked=document.querySelector('input[name="fen1"]:checked');
if(fenChecked){total+= (fenChecked.value==="true")?(weights.Fen/counts.Fen):0; fenChecked.parentElement.classList.add(fenChecked.value==="true"?'correct':'wrong');}

// Progress bar
progress=(total/maxTotal)*100;
document.getElementById('progress').style.width=progress+'%';

document.getElementById('denemeResult').innerText="Deneme Puanı: "+total.toFixed(1)+" / "+maxTotal;

// LocalStorage ile kaydet
localStorage.setItem('lastDenemeScore', total.toFixed(1));
}

// PDF İndir
function downloadDenemePDF(){
const { jsPDF } = window.jspdf;
const doc = new jsPDF();
doc.text("Örnek Deneme",10,10);
doc.text("Matematik: 5+3=?",10,20);
doc.text("Türkçe: Ev kelimesinin çoğulu?",10,30);
doc.text("Fen: Su kaç derecede donar?",10,40);
doc.text("Puan: "+localStorage.getItem('lastDenemeScore')+" / 500",10,50);
doc.save("Deneme.pdf");
}

// Hedef Belirleme
function showGoal(){
let sel=document.getElementById('schoolSelect');
let school=sel.value;
let required=sel.options[sel.selectedIndex].dataset.required;
let avg=document.getElementById('avgScore').value||0;
let diff=required-avg;
let percent=Math.min((avg/required)*100,100);
document.getElementById('goalResult').innerText=`Hedef: ${school}\nGerekli Puan: ${required}\nSizin Puanınız: ${avg}\nHedefe ulaşmak için ${diff} puan daha gerekli.`;
document.getElementById('goalProgress').style.width=percent+'%';
}

// İletişim
function sendMessage(){
let name=document.getElementById('contactName').value;
let email=document.getElementById('contactEmail').value;
let msg=document.getElementById('contactMessage').value;
if(!name||!email||!msg){alert('Tüm alanları doldurun');return;}
document.getElementById('contactResult').innerText='Mesajınız gönderildi!';
}
</script>

</body>
</html>
