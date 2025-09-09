
function ProfilePicture() {
    const handleClick = (e) => e.target.style.display = "none";
    const image = <img onClick={(e) => handleClick(e)} src="./src/assets/fire1.jpg"></img>
    
    return image;
}
export default ProfilePicture