; Flip through "sub-pages" with info

%import page_credits
%import page_usage
%import page_scoring
%import page_scoring_p2

roller {

  const ubyte PAGE_WDT = 40 ; Full width
  const ubyte PAGE_HGT = 6  ; half height sinc page is too big

  const ubyte PAGES = 4
  uword[] pages = [ &page_credits.chars_1, &page_credits.chars_2,
                    &page_usage.chars_1, &page_usage.chars_2,
  	  	    &page_scoring.chars_1, &page_scoring.chars_2,
  	  	    &page_scoring_p2.chars_1, &page_scoring_p2.chars_2 ]
  uword[] colors = [ &page_credits.colors_1, &page_credits.colors_2,
                     &page_usage.colors_1, &page_usage.colors_2,
                     &page_scoring.colors_1, &page_scoring.colors_2,
                     &page_scoring_p2.colors_1, &page_scoring_p2.colors_2 ]

  ubyte page
  ubyte delay_counter

  sub setup() {
    page = 0
    delay_counter = 6    ; Trigger actual draw at setup
    draw()
  }

  sub draw() {
    if delay_counter < 6 {
      delay_counter++
      return
    }
    delay_counter = 0
    
    ubyte page_ind = page * 2 ; (offset 0 or 2 into pages/colors)

    uword pageRef  = pages[page_ind]
    uword pageRef2 = pages[page_ind+1]

    uword colRef  = colors[page_ind]
    uword colRef2 = colors[page_ind+1]
    
    const ubyte HGT_OFFSET = base.UBORDER + 11
    ubyte i
    for i in 0 to (PAGE_WDT * PAGE_HGT - 1) {
      txt.setcc( (i % PAGE_WDT), HGT_OFFSET + (i/PAGE_WDT),
                  pageRef[i], colRef[i] )
      txt.setcc( (i % PAGE_WDT), HGT_OFFSET + PAGE_HGT + (i/PAGE_WDT),
                 pageRef2[i], colRef2[i] )
    }

    ; Temporary and ugly way to print hiscore
    if page == 0 {
      main.printHiscore()
    }

    page++
    if page == PAGES
      page = 0
  }

}
