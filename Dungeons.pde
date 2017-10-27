DungeonBSP map ;
void setup(){
size(600,400);
  map = new DungeonBSP(600,400,100,200);
  map.partition();
  map.Render();

}
void draw(){

  
}