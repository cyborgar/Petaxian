; Cluster bombs dropped by RAIDER4 enemy
;
; These bombs behave as regular bombs until they are close to the
; bottom, and then they "fork" into multiple 
;
; Note that same as regular bombs, the cluster bombs can be on either "half" 
; of a character. Use single "bit" figure
;
; NB! Cluster bombs are defined to be an "subclass" of sorts to 
; normal bombs and can use the same collision detection function in
; gun. I.e it has to have share all parameters from the "bomb" in the
; same position but can have an extra element.
;
cluster_bombs {
  const ubyte COL = 10; 

  const ubyte MAX_CLUSTERS = 3 ; 
  const ubyte FIELD_COUNT = 5

  ubyte active_clusters = 0

  ; Note that the first 3 "records" are the main/middle bomblet
  ; and then we use upper 6 fields when we split cluster (3 left, 3 right)
  ubyte[FIELD_COUNT * MAX_CLUSTERS * 3] clusterData

  const ubyte CLU_ON = 0
  const ubyte CLU_LEFTMOST = 1  ; Which half of "char" to use for column
  const ubyte CLU_X = 2
  const ubyte CLU_Y = 3
  const ubyte CLU_SPLITSIDE = 4 ; Use to handle "split" of cluster

  const ubyte SPLIT_LEFT =  0
  const ubyte SPLIT_MID =   1
  const ubyte SPLIT_RIGHT = 2

  uword clusterRef ; Global to avoid sending reference to subs

  sub set_data() {
    active_clusters = 0
    sys.memset(&clusterData, FIELD_COUNT * MAX_CLUSTERS * 3, 0 )
  }

  sub trigger(ubyte x, ubyte y, ubyte leftmost) {
    if active_clusters == MAX_CLUSTERS 
      return

    clusterRef = &clusterData
    ubyte i = 0
    while i < MAX_CLUSTERS {
      if clusterRef[CLU_ON] == false { ; Find first "free" data field
        clusterRef[CLU_ON] = true
        clusterRef[CLU_SPLITSIDE] = SPLIT_MID

        if leftmost == true { 
          clusterRef[CLU_LEFTMOST] = true
          clusterRef[CLU_X] = x + 1
        } else {
          clusterRef[CLU_LEFTMOST] = false
          clusterRef[CLU_X] = x
        }
        clusterRef[CLU_Y] = y + 1

        draw()
        active_clusters++
        sound.bomb()
        return ; No need to check any more
      }
      clusterRef += FIELD_COUNT
      i++
    }
  }

  sub split(ubyte splitside) {
    uword splitRef = clusterRef
    ubyte tmp_x = clusterRef[CLU_X]    
    ; Make offset into upper cluster index
    if splitside == SPLIT_LEFT {
      splitRef += FIELD_COUNT * 3
      tmp_x--
    } else {      ; SPLIT_RIGHT
      splitRef += FIELD_COUNT * 6
      tmp_x++
    }

    splitRef[CLU_ON] = true
    splitRef[CLU_LEFTMOST] = clusterRef[CLU_LEFTMOST]
    splitRef[CLU_X] = tmp_x
    splitRef[CLU_Y] = clusterRef[CLU_Y]
    splitRef[CLU_SPLITSIDE] = splitside
  }

  sub clear() {
    txt.setcc(clusterRef[CLU_X], clusterRef[CLU_Y], main.CLR, 0)
  }

  ; Can bomb and bullet meet?
  ;
  sub draw() {
    if clusterRef[CLU_LEFTMOST]
      txt.setcc(clusterRef[CLU_X], clusterRef[CLU_Y], 123, COL)
    else
      txt.setcc(clusterRef[CLU_X], clusterRef[CLU_Y], 108, COL)
  }

  sub move() {
    clusterRef = &clusterData
    ubyte i = 0
    while i < (MAX_CLUSTERS * 3) {
      if clusterRef[CLU_ON] == true { 
        clear() ; Clear old position
        clusterRef[CLU_Y]++;
        ubyte tmp_y = clusterRef[CLU_Y]
	
        ; Only the first MAX_CLUSTER are can "split"
        if i < MAX_CLUSTERS { ; Cluster "center bomb"
          if tmp_y == (base.DBORDER - 8) { ; Split bomb
             split(SPLIT_LEFT)
             split(SPLIT_RIGHT)
             sound.bomb()
          }
        } else { ; Adjust cluster "side bombs"
          if tmp_y == (base.DBORDER - 4) { ; Adjust path
            if clusterRef[CLU_SPLITSIDE] == SPLIT_LEFT {
              clusterRef[CLU_X]--
            } else if clusterRef[CLU_SPLITSIDE] == SPLIT_RIGHT {
              clusterRef[CLU_X]++
            }
	  }
        }

        if tmp_y == base.DBORDER {
          clusterRef[CLU_ON] = false
          if i < MAX_CLUSTERS
            active_clusters--
        } else if tmp_y == (base.DBORDER - 1) and
                  gun.check_collision( clusterRef ) {
          clusterRef[CLU_ON] = false
          if i < MAX_CLUSTERS
            active_clusters--
        } else {
          draw()
        }
      }
      clusterRef += FIELD_COUNT
      i++
    }
  }  

}
