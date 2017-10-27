//we're going to need Vectoc class 
import java.util.Vector;
//custom Rectangle to extended more than oncce  
public class CustomRect {
    int x,y, W ,H; // postion, width ,and height
    color clr;  //color 
    //constructor
   public CustomRect(int x , int y , int w, int h, color clr){
   this.x=x;
   this.y=y;
   this.H=h;
   this.W =w;
   this.clr =clr;
   }
   //Helper Method to render to screen
   void render(){
     fill(clr);
     rect(x,y,W,H);
   }
 }
 //Main BinaryTree Class
class DungeonBSP{
     //Node class
    class DungeonNode{
      DungeonNode parent,left,right;
      int x,y, Width ,Height;
      //room with going to be onlt in leaf nodes else this will be null
      class Room extends  CustomRect{
       public Room(int x , int y , int w, int h, color clr){
         super(x ,  y ,  w,  h,  clr);
      }
    }
    Room room;
   //constructor 
     public DungeonNode(int x, int y, int w , int h, DungeonNode p){
       this.x = x;
       this.y = y;
       this.Width = w;
       this.Height= h;
       this.parent =p;
     }
    }

    DungeonNode root; //Root Node
    int minLeafSize , maxLeafSize , H , W; 
    Vector<DungeonNode> nodes; //nodes  
    Vector<CustomRect> rooms;  //the rooms to ease the access
    Vector<CustomRect> Halls; // the halls to ease the render
    //constructor
    public DungeonBSP(int w, int h ,int min , int max) {
      this.H=h;
      this.W=w;
      this.minLeafSize =min;
      this.maxLeafSize = max;
      //new root 
      this.root = new DungeonNode(0,0,this.W,this.H,null);
    }
    //Split the method passed and Veticaly or Horeziantally
    private boolean split(DungeonNode node){
      //if had been split
      if(node.left!=null&&node.right!=null) return false;
      //Random Split 50/50 chance H:True ,V:False
      boolean orienation = random(1)>0.5?true:false; 
      //if the width is 25% more in length than height DO horeiziontal split 
      if(node.Width>node.Height && node.Width/node.Height>=1.25)
        orienation = true;
        //else vertical split
      else if (node.Height>node.Width &&node.Height/node.Width>=1.25)
        orienation = false;
        //max holds the width/height based on H or V split
      int max = (orienation? node.Width:node.Height)-minLeafSize;
      if(max<minLeafSize) return false; //if the Node is too small we cant do more split 
      int splitLocation =(int)random(minLeafSize,max); //random split Location between the minSize and the width/height
      if(orienation){
        node.left = new DungeonNode(node.x,node.y,splitLocation,node.Height,node);
        node.right = new DungeonNode(node.x+splitLocation,node.y,node.Width-splitLocation,node.Height,node);
      }else{
        node.left = new DungeonNode(node.x,node.y,node.Width,splitLocation,node);
        node.right = new DungeonNode(node.x,node.y+splitLocation,node.Width,node.Height-splitLocation, node);
  
        }
      return true;
    }

    //main patiotion that call split for the node starting from root 
    void partition (){
      this.nodes = new Vector<DungeonNode>(); //init the the nodes list
      this.nodes.add(root); 
      boolean do_split = true;
      while(do_split){
         do_split = false;
          for(int i = 0; i < this.nodes.size(); i++){
            if(this.nodes.get(i).left==null&&this.nodes.get(i).right==null){
              //if the leaf is too big (more than max leaf size ) split
              if(this.nodes.get(i).Width>maxLeafSize || this.nodes.get(i).Height>maxLeafSize){
                if(split(this.nodes.get(i))){ // if split is done add the children to nodes
                      this.nodes.add(this.nodes.get(i).left);
                      this.nodes.add(this.nodes.get(i).right);
                      do_split = true;
                  }
               }
            }
         }
      }
    }
    //Main render (leafs -> rooms -> halls )
    public void Render(){
      rooms = new Vector<CustomRect>();
      for(int i = 0; i < this.nodes.size(); i++){
        DungeonNode tmp = this.nodes.get(i);
        //if left and right are null we're on leaf
        if(tmp.left==null&&tmp.right==null){
           //fill(50,50,50);
           noStroke();
           //rect(tmp.x,tmp.y,tmp.Width,tmp.Height); 
           createRooms(tmp); // create and render rooms 
           this.rooms.add(tmp.room); // add to list
        }  
     }
     createHalls();
   }
   
    public void createRooms(DungeonNode n){
      if(n.left==null&&n.right==null){
        int w=(int)(random(this.minLeafSize/2,n.Width-2));
        int h=(int)(random(this.minLeafSize/2,n.Height-2));
        int x=(int)(random(n.x+1,n.Width-w-1));
        int y=(int)(random(n.y+1,n.Height-h-1));
        color c = color(20,58,69);
        n.room = n.new Room(x,y,w,h,c);
        n.room.render();
      }
   }
   public void createHalls(){
     Halls = new Vector<CustomRect>();
    //  createHalls(this.rooms.get(0),this.rooms.get(this.rooms.size()-1));
     for(int i = 1; i < this.rooms.size(); i++){
          CustomRect tmp = this.rooms.get(i-1);
          CustomRect tmp2 = this.rooms.get(i);
          createHalls(tmp,tmp2);
     }
     for(int i = 0; i < this.Halls.size(); i++){
       CustomRect tmpHall = this.Halls.get(i);
       tmpHall.render();
     } 
   }
 private void createHalls(CustomRect left , CustomRect right){
   color clr = color(20,58,69);
   int size = 5;
   int x1 = (int)(random(left.x+1,left.W));
   int x2 = (int)(random(right.x+1,right.W));
   int y1 = (int)(random(left.y+1,left.H));
   int y2 = (int)(random(right.y+1,right.H));
   int w = x2-x1;
   int h = y2-y1;
   if(w<0){
      if(h<0){
         if(random(1)<0.5){
            Halls.add(new CustomRect(x2,y1,abs(w),size,clr));
            Halls.add(new CustomRect(x2,y2,size,abs(h),clr));
           
         }else{
            Halls.add(new CustomRect(x2,y2,abs(w)+size,size,clr));
            Halls.add(new CustomRect(x1,y2,size,abs(h),clr));
         }
      }else if(h>0){
        if(random(1)<0.5){
            Halls.add(new CustomRect(x2,y1,abs(w),size,clr));
            Halls.add(new CustomRect(x2,y1,size,abs(h),clr));
         }else{
            Halls.add(new CustomRect(x2,y2,abs(w)+size,size,clr));
            Halls.add(new CustomRect(x1,y1,size,abs(h),clr));
         }
      }else if (w==0){
       Halls.add(new CustomRect(x2,y2,abs(w)+size,size,clr));
      }
   }else if(w>0){
     if(h<0){
       if(random(1)<0.5){
            Halls.add(new CustomRect(x1,y2,abs(w),size,clr));
            Halls.add(new CustomRect(x1,y2,size,abs(h),clr));
         }else{
            Halls.add(new CustomRect(x1,y1,abs(w)+size,size,clr));
            Halls.add(new CustomRect(x2,y2,size,abs(h),clr));
         }
     }else if(h>0){
       if(random(1)<0.5){
            Halls.add(new CustomRect(x1,y1,abs(w)+size,size,clr));
            Halls.add(new CustomRect(x2,y1,size,abs(h),clr)); 
         }else{
            Halls.add(new CustomRect(x1,y2,abs(w),size,clr));
            Halls.add(new CustomRect(x1,y1,size,abs(h),clr));
         }
     }else if(h==0){
       Halls.add(new CustomRect(x1,y1,abs(w)+size,size,clr));
     }
   }else if(w==0){
    if(h<0){
      Halls.add(new CustomRect(x2,y2,size,abs(h),clr));
    }else if(h>0){
      Halls.add(new CustomRect(x1,y1,size,abs(h),clr));
    }
     
   }
 }


}