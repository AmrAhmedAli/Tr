:- use_module(library(clpfd)).
parent(amr).
trainSchedules(ST, ET, SS, ES, ROUTE):-

    %(ST, StartingTime) in minutes
    %(ET, EndingTime) in minutes
    %(SS, StartingStation) in chars
    %(ES, EndingStation) in chars

    ROUTE = [
       FE,ED,DC,CB,BC,BA,CK,KL,LM,LJ,JL,JH,HI,HG,GD,DG
    ],

    ST = [
        AST, BST, CST, DST, EST, FST, GST, HST,
        IST, JST, KST
    ],

    ET = [
        AET, BET, CET, DET, EET, FET, GET, HET,
        IET, JET, KET
    ],

    SS = [
        ASS, BSS, CSS, DSS, ESS, FSS, GSS, HSS,
        ISS, JSS, KSS
    ],

    ES = [
        AES, BES, CES, DES, EES, FES, GES, HES,
        IES, JES, KES
    ],

    ST ins 0..180, %The latest train cannot start after 180 min.
    ET ins 0..500, %The latest train cannot reach after 360 min.

    FIR in -250..250,
    SEC in -250..250,
    THIR in -250..250,
    FIF in -250..250,
    SIX in -250..250,
    SEV in -250..250,
    EIGH in -250..250,
    NIN in -250..250,
    TEN in -250..250,
    ELE in -250..250,
    %Each variable in the set {A,B,C,...} corresponds to a train number in the set {1,2,3,...}
    %For example (CST, TrainNo.3 Starting Time)
    %(DSS, TrainNo.4 Starting Station)
    %(KES, TrainNo.11 Ending Station)


    %Initializing the set SS, and ES (Starting Station and Ending Station)
    ASS = f,
    BSS = i,
    CSS = i,
    DSS = m,
    ESS = a,
    FSS = a,
    GSS = c,
    HSS = h,
    ISS = m,
    JSS = m,
    KSS = f,

    AES = a,
    BES = a,
    CES = m,
    DES = a,
    EES = j,
    FES = f,
    GES = m,
    HES = f,
    IES = g,
    JES = d,
    KES = i,

    %The Starting Time of each train logically must be less than the ending Time
    AST #< AET,
    BST #< BET,
    CST #< CET,
    DST #< DET,
    EST #< EET,
    FST #< FET,
    GST #< GET,
    HST #< HET,
    IST #< IET,
    JST #< JET,
    KST #< KET,

    %The time (IN MINs) when the trains is ready to depart

    AST #>= 0,
    BST #>= 60,
    CST #>= 30,
    DST #>= 60,
    EST #>= 180,
    FST #>= 120,
    GST #>= 90,
    HST #>= 30,
    IST #>= 60,
    JST #>= 90,
    KST #>= 150,

    %The time (IN MINs) when the trains should reach the destination

    AET #=< 500,
    BET #=< 500,
    CET #=< 500,
    DET #=< 500,
    EET #=< 500,
    FET #=< 500,
    GET #=< 500,
    HET #=< 500,
    IET #=< 500,
    JET #=< 500,
    KET #=< 500,

    final_tasks(SS, ES, ST, ET, FE,ED,DC,CB,BC,BA,CK,KL,LM,LJ,JL,JH,HI,HG,GD,DG),


    cumulative(FE, [limit(1)]),
    cumulative(ED, [limit(1)]),
    cumulative(DC, [limit(1)]),
    cumulative(CB, [limit(1)]),
    cumulative(BC, [limit(1)]),
    cumulative(BA, [limit(1)]),
    cumulative(CK, [limit(1)]),
    cumulative(KL, [limit(1)]),
    cumulative(LM, [limit(1)]),
    cumulative(LJ, [limit(1)]),
    cumulative(JL, [limit(1)]),
    cumulative(JH, [limit(1)]),
    cumulative(HI, [limit(1)]),
    cumulative(HG, [limit(1)]),
    cumulative(GD, [limit(1)]),
    cumulative(DG, [limit(1)]),

    FIR #= AET - 240,
    SEC #= BET - 270,
    THIR #= CET - 210,
    FOR #= DET - 300,
    FIF #= EET - 360,
    SIX #= FET - 330,
    SEV #= GET - 240,
    EIGH #= HET - 210,
    NIN #= IET - 300,
    TEN #= JET - 300,
    ELE #= KET - 300,
    SUM #= FIR+SEC+THIR+FOR+FIF+SIX+SEV+EIGH+NIN+TEN+ELE,
    labeling([min(SUM)],[AET, BET, CET, DET, EET, FET, GET, HET,IET, JET, KET]).


optimize(ST, ET, SS, ES):-
    ST = [
        AST, BST, CST, DST, EST, FST, GST, HST,
        IST, JST, KST
    ],

    ET = [
        AET, BET, CET, DET, EET, FET, GET, HET,
        IET, JET, KET
    ],

    SS = [
        ASS, BSS, CSS, DSS, ESS, FSS, GSS, HSS,
        ISS, JSS, KSS
    ],

    ES = [
        AES, BES, CES, DES, EES, FES, GES, HES,
        IES, JES, KES
    ],
    trainSchedules(ST, ET, SS, ES),
    (((AET #> 240) #==> FIR #= AET - 240); FIR #= 0),
    (((BET #> 270) #==> SEC #= BET - 270); SEC #= 0),
    (((CET #> 210) #==> THIR #= CET - 210); THIR #= 0),
    (((DET #> 300) #==> FOR #= DET - 300); FOR #= 0),
    (((EET #> 360) #==> FIF #= EET - 360); FIF #= 0),
    (((FET #> 330) #==> SIX #= FET - 330); SIX #= 0),
    (((GET #> 240) #==> SEV #= GET - 240); SEV #= 0),
    (((HET #> 210) #==> EIGH #= HET - 210); EIGH #= 0),
    (((IET #> 300) #==> NIN #= IET - 300); NIN #= 0),
    (((JET #> 300) #==> TEN #= JET - 300); TEN #= 0),
    (((KET #> 300) #==> ELE #= KET - 300); ELE #= 0),
    sumlist([FIR,SEC,THIR,FOR,FIF,SIX,SEV,EIGH,NIN,TEN,ELE], SUM),
    labeling([min(SUM)],[SUM]).


%final_tasks([f,i,i,m,a,a,c,h,m,m,f],[a,a,m,a,j,f,m,f,g,d,i],[0,30,60,0,20,30,60,0,0,10,30],[120,240,260,200,220,230,260,200,200,210,230],FE,ED,DC,CB,BC,BA,CK,KL,LM,LJ,JL,JH,HI,HG,GD,DG)
final_tasks(SS, ES, ST, ET, FE,ED,DC,CB,BC,BA,CK,KL,LM,LJ,JL,JH,HI,HG,GD,DG):-
    ST = [
        AST, BST, CST, DST, EST, FST, GST, HST,
        IST, JST, KST
    ],

    ET = [
        AET, BET, CET, DET, EET, FET, GET, HET,
        IET, JET, KET
    ],

    SS = [
        ASS, BSS, CSS, DSS, ESS, FSS, GSS, HSS,
        ISS, JSS, KSS
    ],

    ES = [
        AES, BES, CES, DES, EES, FES, GES, HES,
        IES, JES, KES
    ],

    possible_route(ASS, AES, AL),
    generate_tasks(AL,1, AST,AET, AFE,AED,ADC,ACB,ABC,ABA,ACK,AKL,ALM,ALJ,AJL,AJH,AHI,AHG,AGD,ADG),

    possible_route(BSS, BES, BL),
    generate_tasks(BL,2, BST, BET, BFE,BED,BDC,BCB,BBC,BBA,BCK,BKL,BLM,BLJ,BJL,BJH,BHI,BHG,BGD,BDG),

    possible_route(CSS, CES, CL),
    generate_tasks(CL,3, CST, CET, CFE,CED,CDC,CCB,CBC,CBA,CCK,CKL,CLM,CLJ,CJL,CJH,CHI,CHG,CGD,CDG),

    possible_route(DSS, DES, DL),
    generate_tasks(DL,4, DST, DET, DFE,DED,DDC,DCB,DBC,DBA,DCK,DKL,DLM,DLJ,DJL,DJH,DHI,DHG,DGD,DDG),

    possible_route(ESS, EES, EL),
    generate_tasks(EL,5, EST, EET, EFE,EED,EDC,ECB,EBC,EBA,ECK,EKL,ELM,ELJ,EJL,EJH,EHI,EHG,EGD,EDG),

    possible_route(FSS, FES, FL),
    generate_tasks(FL,6, FST, FET, FFE,FED,FDC,FCB,FBC,FBA,FCK,FKL,FLM,FLJ,FJL,FJH,FHI,FHG,FGD,FDG),

    possible_route(GSS, GES, GL),
    generate_tasks(GL,7, GST, GET, GFE,GED,GDC,GCB,GBC,GBA,GCK,GKL,GLM,GLJ,GJL,GJH,GHI,GHG,GGD,GDG),

    possible_route(HSS, HES, HL),
    generate_tasks(HL,8, HST, HET, HFE,HED,HDC,HCB,HBC,HBA,HCK,HKL,HLM,HLJ,HJL,HJH,HHI,HHG,HGD,HDG),

    possible_route(ISS, IES, IL),
    generate_tasks(IL,9, IST, IET, IFE,IED,IDC,ICB,IBC,IBA,ICK,IKL,ILM,ILJ,IJL,IJH,IHI,IHG,IGD,IDG),

    possible_route(JSS, JES, JLL),
    generate_tasks(JLL,10, JST, JET, JFE,JED,JDC,JCB,JBC,JBA,JCK,JKL,JLM,JLJ,JJL,JJH,JHI,JHG,JGD,JDG),

    possible_route(KSS, KES, KLL),
    generate_tasks(KLL,11, KST, KET, KFE,KED,KDC,KCB,KBC,KBA,KCK,KKL,KLM,KLJ,KJL,KJH,KHI,KHG,KGD,KDG),

    concat_tasks(AFE, BFE, CFE, DFE, EFE, FFE, GFE, HFE, IFE, JFE, KFE, FE),
    concat_tasks(AED, BED, CED, DED, EED, FED, GED, HED, IED, JED, KED, ED),
    concat_tasks(ADC, BDC, CDC, DDC, EDC, FDC, GDC, HDC, IDC, JDC, KDC, DC),
    concat_tasks(ACB, BCB, CCB, DCB, ECB, FCB, GCB, HCB, ICB, JCB, KCB, CB),
    concat_tasks(ABC, BBC, CBC, DBC, EBC, FBC, GBC, HBC, IBC, JBC, KBC, BC),
    concat_tasks(ABA, BBA, CBA, DBA, EBA, FBA, GBA, HBA, IBA, JBA, KBA, BA),
    concat_tasks(ACK, BCK, CCK, DCK, ECK, FCK, GCK, HCK, ICK, JCK, KCK, CK),
    concat_tasks(AKL, BKL, CKL, DKL, EKL, FKL, GKL, HKL, IKL, JKL, KKL, KL),
    concat_tasks(ALM, BLM, CLM, DLM, ELM, FLM, GLM, HLM, ILM, JLM, KLM, LM),
    concat_tasks(ALJ, BLJ, CLJ, DLJ, ELJ, FLJ, GLJ, HLJ, ILJ, JLJ, KLJ, LJ),
    concat_tasks(AJL, BJL, CJL, DJL, EJL, FJL, GJL, HJL, IJL, JJL, KJL, JL),
    concat_tasks(AJH, BJH, CJH, DJH, EJH, FJH, GJH, HJH, IJH, JJH, KJH, JH),
    concat_tasks(AHI, BHI, CHI, DHI, EHI, FHI, GHI, HHI, IHI, JHI, KHI, HI),
    concat_tasks(AHG, BHG, CHG, DHG, EHG, FHG, GHG, HHG, IHG, JHG, KHG, HG),
    concat_tasks(AGD, BGD, CGD, DGD, EGD, FGD, GGD, HGD, IGD, JGD, KGD, GD),
    concat_tasks(ADG, BDG, CDG, DDG, EDG, FDG, GDG, HDG, IDG, JDG, KDG, DG).

concat_tasks(AFE, BFE, CFE, DFE, EFE, FFE, GFE, HFE, IFE, JFE, KFE, FE):-
    (
        (
            (AFE = [] , TempFE = []);
            (is_list(AFE) , append([],AFE, TempFE))

        ),
        (
            (BFE = [], Temp2FE = TempFE);
            (is_list(BFE) , append(BFE,TempFE,Temp2FE))

        ),
        (
            (CFE = [], Temp3FE = Temp2FE);
            (is_list(CFE) , append(CFE,Temp2FE,Temp3FE))

        ),
        (
            (DFE = [], Temp4FE = Temp3FE);
            (is_list(DFE) , append(DFE,Temp3FE,Temp4FE))

        ),
        (
            (EFE = [], Temp5FE = Temp4FE);
            (is_list(EFE) , append(EFE,Temp4FE,Temp5FE))

        ),
        (
            (FFE = [], Temp6FE = Temp5FE);
            (is_list(FFE) , append(FFE,Temp5FE,Temp6FE))

        ),
        (
            (GFE = [], Temp7FE = Temp6FE);
            (is_list(GFE) , append(GFE,Temp6FE,Temp7FE))

        ),
        (
            (HFE = [], Temp8FE = Temp7FE);
            (is_list(HFE) , append(HFE,Temp7FE,Temp8FE))

        ),
        (
            (IFE = [], Temp9FE = Temp8FE);
            (is_list(IFE) , append(IFE,Temp8FE,Temp9FE))

        ),
        (
            (JFE = [], Temp10FE = Temp9FE);
            (is_list(JFE) , append(JFE,Temp9FE,Temp10FE))

        ),
        (
            (KFE = [], FE = Temp10FE);
            (is_list(KFE) , append(KFE,Temp10FE,FE))

        )
    ).




%For Testing
%generate_tasks([(f,e,35,1), (e,d,35,1), (d,c,50,1), (c,b,40,1)], 0, 120, FE,ED,DC,CB,BC,BA,CK,KL,LM,LJ,JL,JH,HI,HG,GD,DG)
%((FENewList = [] , FETasks = Member);(is_list(FENewList),append(Member,FENewList,FETasks)))

generate_tasks([(SS,ES,Duration,Lim)],ID,XST,END, FETasks, EDTasks, DCTasks,
                                                    CBTasks, BCTasks, BATasks,
                                                    CKTasks, KLTasks, LMTasks,
                                                    LJTasks, JLTasks, JHTasks,
                                                    HITasks, HGTasks, GDTasks,
                                                    DGTasks):-
            (
                (
                    SS = f,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    FETasks = Member
                );

                (
                    SS = e, ES = f,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    FETasks = Member
                );

                (
                    SS = e, ES = d,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    EDTasks = Member
                );

                (
                    SS = d, ES = e,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    EDTasks = Member

                );

                (
                    SS = d, ES = c,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    DCTasks = Member

                );

                (
                    SS = c, ES = d,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    DCTasks = Member

                );

                (
                    SS = b, ES = c,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    BCTasks = Member

                );

                (
                    SS = c, ES = b,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    CBTasks = Member

                );

                (
                    SS = b, ES = a,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    BATasks = Member

                );

                (
                    SS = a, ES = b,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    BATasks = Member

                );

                (
                    SS = c, ES = k,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    CKTasks = Member

                );

                (
                    SS = k, ES = c,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    CKTasks = Member

                );

                (
                    SS = k, ES = l,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    KLTasks = Member


                );

                (
                    SS = l, ES = k,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    KLTasks = Member

                );

                (
                    SS = l, ES = m,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    LMTasks = Member

                );

                (
                    SS = m, ES = l,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    LMTasks = Member

                );

                (
                    SS = l, ES = j,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    LJTasks = Member

                );

                (
                    SS = j, ES = l,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    JLTasks = Member

                );

                (
                    SS = j, ES = h,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    JHTasks = Member

                );

                (
                    SS = h, ES = j,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    JHTasks = Member

                );

                (
                    SS = h, ES = i,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    HITasks = Member


                );

                (
                    SS = i, ES = h,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    HITasks = Member

                );

                (
                    SS = h, ES = g,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    HGTasks = Member

                );

                (
                    SS = g, ES = h,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    HGTasks = Member

                );

                (
                    SS = g, ES = d,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    GDTasks = Member

                );

                (
                    SS = d, ES = g,
                    END #= XST+Duration,
                    Member = [task(XST, Duration, END, 1,ID)],
                    DGTasks = Member
                )
            ).
generate_tasks([(SS,ES,Duration,Lim)|TrainXT],ID, XST,END, FETasks, EDTasks, DCTasks,
                                                    CBTasks, BCTasks, BATasks,
                                                    CKTasks, KLTasks, LMTasks,
                                                    LJTasks, JLTasks, JHTasks,
                                                    HITasks, HGTasks, GDTasks,
                                                    DGTasks):-
            (
                (
                    SS = f,
                    generate_tasks(TrainXT,ID,XET, END, FENewList, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    FETasks = Member
                );

                (
                    SS = e, ES = f,
                    generate_tasks(TrainXT,ID,XET, END, FENewList,EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    FETasks = Member
                );

                (
                    SS = e, ES = d,
                    generate_tasks(TrainXT,ID,XET, END, FETasks, EDNewList, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    EDTasks = Member
                );

                (
                    SS = d, ES = e,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDNewList, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    EDTasks = Member

                );

                (
                    SS = d, ES = c,
                    generate_tasks(TrainXT,ID,XET, END, FETasks, EDTasks, DCNewList,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    DCTasks = Member

                );

                (
                    SS = c, ES = d,
                    generate_tasks(TrainXT,ID,XET, END, FETasks, EDTasks, DCNewList,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    DCTasks = Member

                );

                (
                    SS = b, ES = c,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCNewList, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    BCTasks = Member

                );

                (
                    SS = c, ES = b,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBNewList, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    CBTasks = Member

                );

                (
                    SS = b, ES = a,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BANewList,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    BATasks = Member

                );

                (
                    SS = a, ES = b,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BANewList,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    BATasks = Member

                );

                (
                    SS = c, ES = k,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKNewList, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    CKTasks = Member

                );

                (
                    SS = k, ES = c,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKNewList, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    CKTasks = Member

                );

                (
                    SS = k, ES = l,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLNewList, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    KLTasks = Member


                );

                (
                    SS = l, ES = k,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLNewList, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    KLTasks = Member

                );

                (
                    SS = l, ES = m,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMNewList,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    LMTasks = Member

                );

                (
                    SS = m, ES = l,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMNewList,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    LMTasks = Member

                );

                (
                    SS = l, ES = j,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJNewList, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    LJTasks = Member

                );

                (
                    SS = j, ES = l,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLNewList, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    JLTasks = Member

                );

                (
                    SS = j, ES = h,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHNewList,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    JHTasks = Member

                );

                (
                    SS = h, ES = j,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHNewList,
                                                HITasks, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    JHTasks = Member

                );

                (
                    SS = h, ES = i,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HINewList, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    HITasks = Member


                );

                (
                    SS = i, ES = h,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HINewList, HGTasks, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    HITasks = Member

                );

                (
                    SS = h, ES = g,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGNewList, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    HGTasks = Member

                );

                (
                    SS = g, ES = h,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGNewList, GDTasks,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    HGTasks = Member

                );

                (
                    SS = g, ES = d,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDNewList,
                                                DGTasks),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    GDTasks = Member

                );

                (
                    SS = d, ES = g,
                    generate_tasks(TrainXT,ID,XET,END, FETasks, EDTasks, DCTasks,
                                                CBTasks, BCTasks, BATasks,
                                                CKTasks, KLTasks, LMTasks,
                                                LJTasks, JLTasks, JHTasks,
                                                HITasks, HGTasks, GDTasks,
                                                DGNewList),
                    XET #= XST+Duration,
                    Member = [task(XST, Duration, XET, 1,ID)],
                    DGTasks = Member
                )
            ).




%This Simulates the Graph Given in the Description.
%Query. will see if any two stations are connected.
%If yes the corresponding duration will be set.

connection(StationA, StationB, Duration):-
    (
        (StationA = f, StationB = e, Duration = 35);
        (StationA = e, StationB = f, Duration = 35);
        (StationA = e, StationB = d, Duration = 35);
        (StationA = d, StationB = e, Duration = 35);
        (StationA = d, StationB = c, Duration = 50);
        (StationA = c, StationB = d, Duration = 50);
        (StationA = d, StationB = g, Duration = 30);
        (StationA = g, StationB = d, Duration = 30);
        (StationA = c, StationB = b, Duration = 40);
        (StationA = b, StationB = c, Duration = 40);
        (StationA = b, StationB = a, Duration = 40);
        (StationA = a, StationB = b, Duration = 40);
        (StationA = c, StationB = k, Duration = 60);
        (StationA = k, StationB = c, Duration = 60);
        (StationA = k, StationB = l, Duration = 60);
        (StationA = l, StationB = k, Duration = 60);
        (StationA = l, StationB = m, Duration = 20);
        (StationA = m, StationB = l, Duration = 20);
        (StationA = l, StationB = j, Duration = 60);
        (StationA = j, StationB = l, Duration = 60);
        (StationA = j, StationB = h, Duration = 30);
        (StationA = h, StationB = j, Duration = 30);
        (StationA = h, StationB = i, Duration = 25);
        (StationA = i, StationB = h, Duration = 25);
        (StationA = h, StationB = g, Duration = 30);
        (StationA = g, StationB = h, Duration = 30)
    ).

possible_route(StationA, StationB, List):-
   ( (StationA = f, StationB = a, List = [
                                        (f,e,35,1),(e,d,35,1),
                                        (d,c,50,1),(c,b,40,2),
                                        (b,a,40,1)
                                        ]
    );
    (StationA = f, StationB = a, List = [
                                        (f,e,35,1),(e,d,35,1),
                                        (d,g,30,2),(g,h,30,1),
                                        (h,j,30,1),(j,l,60,2),
                                        (l,k,60,1),(k,c,60,1),
                                        (c,b,40,2),(b,a,40,1)
                                        ]
    );
    (StationA = i, StationB = a, List = [
                                        (i,h,25,1),(h,j,30,1),
                                        (j,l,60,2),(l,k,60,1),
                                        (k,c,60,1),(c,b,40,2),
                                        (b,a,40,1)
                                        ]
    );
    (StationA = i, StationB = a, List = [
                                        (i,h,25,1),(h,g,30,1),
                                        (g,d,30,2),(d,c,50,1),
                                        (c,b,40,2),(b,a,40,1)
                                        ]
    );
    (StationA = i, StationB = m, List = [
                                        (i,h,25,1),(h,g,30,1),
                                        (g,d,30,2),(d,c,50,1),
                                        (c,k,60,1),(k,l,60,1),
                                        (l,m,20,1)
                                        ]
    );
    (StationA = i, StationB = m, List = [
                                        (i,h,25,1),(h,j,30,1),
                                        (j,l,60,2),(l,m,20,1)
                                        ]
    );
    (StationA = m, StationB = a, List = [
                                        (m,l,20,1),(l,k,60,1),
                                        (k,c,60,1),(c,b,40,2),
                                        (b,a,40,1)
                                        ]
    );
    (StationA = m, StationB = a, List = [
                                        (m,l,20,1),(l,j,60,2),
                                        (j,h,30,1),(h,g,30,1),
                                        (g,d,30,2),(d,c,50,1),
                                        (c,b,40,2),(b,a,40,1)
                                        ]
    );
    (StationA = a, StationB = j, List = [
                                        (a,b,40,1),(b,c,40,2),
                                        (c,d,50,1),(d,g,30,2),
                                        (g,h,30,1),(h,j,30,1)
                                        ]
    );
    (StationA = a, StationB = j, List = [
                                        (a,b,40,1),(b,c,40,2),
                                        (c,k,60,1),(k,l,60,1),
                                        (l,j,60,2)
                                        ]
    );
    (StationA = a, StationB = f, List = [
                                        (a,b,40,1),(b,c,40,2),
                                        (c,d,50,1),(d,e,35,1),
                                        (e,f,35,1)
                                        ]
    );
    (StationA = a, StationB = f, List = [
                                        (a,b,40,1),(b,c,40,2),
                                        (c,k,60,1),(k,l,60,1),
                                        (l,j,60,2),(j,h,30,1),
                                        (h,g,30,1),(g,d,30,2),
                                        (d,e,35,1),(e,f,35,1)
                                        ]
    );
    (StationA = c, StationB = m, List = [
                                        (c,d,50,1),(d,g,30,2),
                                        (g,h,30,1),(h,j,30,1),
                                        (j,l,60,2),(l,m,20,1)
                                        ]
    );
    (StationA = c, StationB = m, List = [
                                        (c,k,60,1),(k,l,60,1),
                                        (l,m,20,1)
                                        ]
    );
    (StationA = h, StationB = f, List = [
                                        (h,j,30,1),(j,l,60,2),
                                        (l,k,60,1),(k,c,60,1),
                                        (c,d,50,1),(d,e,35,1),
                                        (e,f,35,1)
                                        ]
    );
    (StationA = h, StationB = f, List = [
                                        (h,g,30,1),(g,d,30,2),
                                        (d,e,35,1),(e,f,35,1)
                                        ]
    );
    (StationA = m, StationB = g, List = [
                                        (m,l,20,1),(l,k,60,1),
                                        (k,c,60,1),(c,d,50,1),
                                        (d,g,30,2)
                                        ]
    );
    (StationA = m, StationB = g, List = [
                                        (m,l,20,1),(l,j,60,2),
                                        (j,h,30,1),(h,g,30,1)
                                        ]
    );
    (StationA = m, StationB = d, List = [
                                        (m,l,20,1),(l,k,60,1),
                                        (k,c,60,1),(c,d,50,1)
                                        ]
    );
    (StationA = m, StationB = d, List = [
                                        (m,l,20,1),(l,j,60,2),
                                        (j,h,30,1),(h,g,30,1),
                                        (g,d,30,2)
                                        ]
    );
    (StationA = f, StationB = i, List = [
                                        (f,e,35,1),(e,d,35,1),
                                        (d,c,50,1),(c,k,60,2),
                                        (k,l,60,1),(l,j,60,2),
                                        (j,h,30,1),(h,i,25,1)
                                        ]
    );
    (StationA = f, StationB = i, List = [
                                        (f,e,35,1),(e,d,35,1),
                                        (d,g,30,2),(g,h,30,1),
                                        (h,i,25,1)
                                        ]
    )).
