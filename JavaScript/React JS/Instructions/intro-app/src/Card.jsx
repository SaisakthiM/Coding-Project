import Img from './assets/fire.jpg'
function Card() {
    return (
        <div className="card">
            <img className="image_card" src={Img} alt="Profile Picture" ></img>
            <h2 className="title_card">Saisakthi</h2>
            <p className="card-text">I am a student studying class 12</p>
        </div>
    );

}
export default Card