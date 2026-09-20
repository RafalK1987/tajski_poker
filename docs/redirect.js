const target=new URL('https://tajski-poker.rafal-klodos-tajski-poker.workers.dev');
const room=new URL(location.href).searchParams.get('room')?.toUpperCase();
if(room&&/^[A-Z2-9]{10}$/.test(room))target.searchParams.set('room',room);
document.getElementById('play-link').href=target.href;
location.replace(target.href);
