SetFactory("OpenCASCADE");

//Variables

//Vertical z
npverz = 30; //Number of pores
rvoidverz = 0.0009; //Real void size
rsolidverz = 0.0045; //Real solid size
Lverz = rvoidverz + rsolidverz; //Real total size of a unit of void+solid, 0.0054
Averz = Lverz*npverz; //Size of the vertical dimension of the rectangular mesh, 0.162

//Horizontal x
nphorx = 30; //Number of pores
rvoidhorx = 0.0009; //Real void size
rsolidhorx = 0.0045; //Real solid size
Lhorx = rvoidhorx + rsolidhorx; //Real total size of a unit of void+solid, 0.0054
Ahorx = Lhorx*nphorx; //Size of the vertical dimension of the rectangular mesh, 0.162

//Mesh size
lm = 0.5;

//Yposition of the plane
y = 0;

//Point definition
ni = nphorx*2+1;
nj = npverz*2+1;
a = 0;
b = 0;
x = 0;
z = 0;
imin = 0;
jmin = 0;

For i In {1:ni}
	imin = i-1;
	If (Fmod(imin, 2) == 0)
		a = (i-1)/2;
		x = a*Lhorx;
	Else
		a = (i-2)/2;
		x = a*Lhorx+rvoidhorx;
	EndIf
	For j In {1:nj}
		jmin = j-1;
		If (Fmod(jmin, 2) == 0)
			b = (j-1)/2;
			z = b*Lverz;
		Else
			b = (j-2)/2;
			z = b*Lverz+rvoidverz;
		EndIf
		Point (jmin*ni+i) = {x, y, z, lm};
	EndFor
EndFor
			
//Line definition
lt = 0; //Line number tracker
ni = nphorx*2;
nj = npverz*2;

For j In {1:nj}
	For i In {1:ni}
		If (j == 1)
			If (Fmod(i,2) == 0)
				Line(4*((i/2)-1)+1) = {((j-1)*(ni+1)+i), ((j-1)*(ni+1)+i+1)};
				Line(4*((i/2)-1)+2) = {((j-1)*(ni+1)+i+1), (j*(ni+1)+i+1)};
				Line(4*((i/2)-1)+3) = {(j*(ni+1)+i+1), (j*(ni+1)+i)};
				Line(4*((i/2)-1)+4) = {(j*(ni+1)+i), ((j-1)*(ni+1)+i)};
				lt = lt+4;
			EndIf
		ElseIf (Fmod(j,2) == 0)
			If (j == 2)
				If (i == 1)
					Line(lt+1) = {((j-1)*(ni+1)+i), ((j-1)*(ni+1)+i+1)};
					Line(lt+2) = {((j-1)*(ni+1)+i+1), (j*(ni+1)+i+1)};
					Line(lt+3) = {(j*(ni+1)+i+1), (j*(ni+1)+i)};
					Line(lt+4) = {(j*(ni+1)+i), ((j-1)*(ni+1)+i)};
					lt = lt+4;
				ElseIf (Fmod(i,2) == 0)
					If (i == 2)
						Line(lt+1) = {((j-1)*(ni+1)+i+1), (j*(ni+1)+i+1)};
						Line(lt+2) = {(j*(ni+1)+i+1), (j*(ni+1)+i)};
						lt = lt+2;
					Else
						Line(lt+1) = {((j-1)*(ni+1)+i+1), (j*(ni+1)+i+1)};
						Line(lt+2) = {(j*(ni+1)+i+1), (j*(ni+1)+i)};
						lt = lt+2;
					EndIf
				Else
					Line(lt+1) = {((j-1)*(ni+1)+i), ((j-1)*(ni+1)+i+1)};
					Line(lt+2) = {((j-1)*(ni+1)+i+1), (j*(ni+1)+i+1)};
					Line(lt+3) = {(j*(ni+1)+i+1), (j*(ni+1)+i)};
					lt = lt+3;
				EndIf
			Else
				If (i == 1)
					Line(lt+1) = {((j-1)*(ni+1)+i), ((j-1)*(ni+1)+i+1)};
					Line(lt+2) = {((j-1)*(ni+1)+i+1), (j*(ni+1)+i+1)};
					Line(lt+3) = {(j*(ni+1)+i+1), (j*(ni+1)+i)};
					Line(lt+4) = {(j*(ni+1)+i), ((j-1)*(ni+1)+i)};
					lt = lt+4;
				ElseIf (Fmod(i,2) == 0)
					If (i == 2)
						Line(lt+1) = {((j-1)*(ni+1)+i+1), (j*(ni+1)+i+1)};
						Line(lt+2) = {(j*(ni+1)+i+1), (j*(ni+1)+i)};
						lt = lt+2;
					Else
						Line(lt+1) = {((j-1)*(ni+1)+i+1), (j*(ni+1)+i+1)};
						Line(lt+2) = {(j*(ni+1)+i+1), (j*(ni+1)+i)};
						lt = lt+2;
					EndIf
				Else
					Line(lt+1) = {((j-1)*(ni+1)+i), ((j-1)*(ni+1)+i+1)};
					Line(lt+2) = {((j-1)*(ni+1)+i+1), (j*(ni+1)+i+1)};
					Line(lt+3) = {(j*(ni+1)+i+1), (j*(ni+1)+i)};
					lt = lt+3;
				EndIf
			EndIf
		Else
			If (Fmod(i,2) == 0)
					Line(lt+1) = {((j-1)*(ni+1)+i+1), (j*(ni+1)+i+1)};
					Line(lt+2) = {(j*(ni+1)+i+1), (j*(ni+1)+i)};
					Line(lt+3) = {(j*(ni+1)+i), ((j-1)*(ni+1)+i)};
					lt = lt+3;
			EndIf
		EndIf
	EndFor
EndFor

b0 = 0;	
// Definition of the curve loops to be removed
For j In {1:nj}
	For i In {1:ni}
		If ((Fmod(j,2) != 0) && (j != 1))
			If ((Fmod(i,2) != 0) && (i != 1))
				a0 = 4*nphorx+9+5*(Floor(i/2)-1)+(Floor(j/2)-1)*(2*(nphorx-1)+3*(nphorx-2)+3*nphorx+4+2+3);
				a11 = 2*(nphorx-Floor(i/2));
				a12 = 3*(nphorx-Ceil(i/2));
				a13 = 3*(Floor(i/2)+1);
				a1 = a0+a11+a12+a13;
				a21 = 2*(nphorx-Floor(i/2));
				a22 = 3*(nphorx-Ceil(i/2));
				a23 = 3*nphorx;
				a24 = 4;
				a25 = 2*Floor(i/2);
				a26 = 3*(Floor(i/2)-1);
				a27 = 1;
				a2 = a0+a21+a22+a23+a24+a25+a26+a27;
				a31 = 2*(nphorx-Floor(i/2));
				a32 = 3*(nphorx-Ceil(i/2));
				a33 = 3*(Floor(i/2)-1);
				a34 = 1;
				a3 = a0+a31+a32+a33+a34;
				b0 = Floor(i/2)+(nphorx-1)*(Floor(j/2)-1);
				Curve Loop(b0) = {-a0,-a1,-a2,-a3};
				//Printf("CurveLoop['%g'] = {'%g', '%g', '%g', '%g'}", b0, -a0, -a1, -a2, -a3);
			EndIf
		EndIf
	EndFor
EndFor
//Printf("Final b0 = '%g'", b0);

// Definition of bounding curve loop (do manually)
CurveLoopList[]=0;
cllt = 0;
j=1;
For i In {1:ni}
	If (Fmod(i,2) == 0)
		If (i == 2)
			CurveLoopList(0) = 4*((i/2)-1)+4;
			CurveLoopList(1) = 4*((i/2)-1)+1;
			CurveLoopList(2) = 4*((i/2)-1)+2;
			cllt = cllt+2;
			
		Else
			CurveLoopList(cllt+1) = 4*nphorx+4+2*((i/2)-1)+3*((i/2)-2)+1;
			CurveLoopList(cllt+2) = 4*((i/2)-1)+4;
			CurveLoopList(cllt+3) = 4*((i/2)-1)+1;
			CurveLoopList(cllt+4) = 4*((i/2)-1)+2;
			cllt = cllt+4;
		EndIf
	EndIf
EndFor

// Diagnostic
//For i In {1:39}
//	Printf("CurveLoopList['%g'] ='%g'",(i-1), CurveLoopList(i-1));
//EndFor
//Printf("cllt = '%g'", cllt);
//Printf("CurveLoopList['%g'] ='%g'",(cllt), CurveLoopList(cllt));

k = cllt;

i = ni;
For j In {1:nj}
	If (j != 1)
		If (Fmod(j,2) == 0)
			If (j == 2)
				CurveLoopList(k+(j-1)) = CurveLoopList(k)+2+4+(2*nphorx)+(3*(nphorx-1))-1;
				cllt = k+1;
			Else
				CurveLoopList(cllt+1) = CurveLoopList(cllt)+2+4+(2*nphorx)+(3*(nphorx-1))-1;
				cllt = cllt+1;
			EndIf
		Else 
			CurveLoopList(cllt+1) = CurveLoopList(cllt)+1+(3*nphorx)-2;
			cllt = cllt+1;
		EndIf
	EndIf
EndFor

// Diagnostic
//For j In {1:nj}
//	Printf("CurveLoopList['%g'] ='%g'",(k+(j-1)), CurveLoopList(k+(j-1)));
//EndFor
//Printf("Final cllt = '%g'", cllt);
//Printf("CurveLoopList['%g'] ='%g'",(cllt), CurveLoopList(cllt));

j = nj;
k = cllt;

For i In {ni:1:(-1)}
	If (i == ni)
		CurveLoopList(cllt+1) = CurveLoopList(cllt)+1;
		cllt = cllt+1;
	ElseIf (i == 1)
		CurveLoopList(cllt+1) = CurveLoopList(cllt)-3;
		cllt = cllt+1;
	Else
		If (Fmod(i,2) != 0)
			CurveLoopList(cllt+1) = CurveLoopList(cllt)-2;
			cllt = cllt+1;
		Else
			CurveLoopList(cllt+1) = CurveLoopList(cllt)-3;
			cllt = cllt+1;
		EndIf
	EndIf
EndFor

// Diagnostic
//For i In {1:ni}
//	Printf("CurveLoopList['%g'] ='%g'",(k+i), CurveLoopList(k+i));
//EndFor
//Printf("Final cllt = '%g'", cllt);
//Printf("CurveLoopList['%g'] ='%g'",(cllt), CurveLoopList(cllt));

i = 1;
k = cllt;

For j In {nj:1:(-1)}
	If (Fmod(j,2) == 0)
		If (j == nj)
			CurveLoopList(cllt+1) = CurveLoopList(cllt)+1;
			CurveLoopList(cllt+2) = CurveLoopList(cllt+1)-3;
			CurveLoopList(cllt+3) = CurveLoopList(cllt+1)-(3*(nphorx-1)+4);
			CurveLoopList(cllt+4) = CurveLoopList(cllt+1)-(3*(nphorx-1)+4+1+2*nphorx+3*(nphorx-1)+3);
			cllt = cllt+4;
		ElseIf (j == 2)
			CurveLoopList(cllt+1) = CurveLoopList(cllt)+1;
			CurveLoopList(cllt+2) = CurveLoopList(cllt+1)-3;
			cllt = cllt+2;
		Else
			CurveLoopList(cllt+1) = CurveLoopList(cllt)+1;
			CurveLoopList(cllt+2) = CurveLoopList(cllt+1)-3;
			CurveLoopList(cllt+3) = CurveLoopList(cllt+1)-(3*(nphorx-1)+4);
			CurveLoopList(cllt+4) = CurveLoopList(cllt+1)-(3*(nphorx-1)+4+1+2*nphorx+3*(nphorx-1)+3);
			cllt = cllt+4;
		EndIf
	EndIf
EndFor

// Diagnostic
//For j In {1:38}
//	Printf("CurveLoopList['%g'] ='%g'",(k+j), CurveLoopList(k+j));
//EndFor
Printf("Final cllt = '%g'", cllt);
//Printf("CurveLoopList['%g'] = '%g'",(cllt), CurveLoopList(cllt));

// Generate using last cllt in ChatGPT 0-cllt
// Prompt for ChatGPT: Could you generate a text with the following rule
// {CurveLoopList(0), CurveLoopList(1), CurveLoopList(2),.....}; this continues until cllt

Curve Loop(b0+1) = {CurveLoopList(0), CurveLoopList(1), CurveLoopList(2), CurveLoopList(3), CurveLoopList(4), CurveLoopList(5), CurveLoopList(6), CurveLoopList(7), CurveLoopList(8), CurveLoopList(9), CurveLoopList(10), CurveLoopList(11), CurveLoopList(12), CurveLoopList(13), CurveLoopList(14), CurveLoopList(15), CurveLoopList(16), CurveLoopList(17), CurveLoopList(18), CurveLoopList(19), CurveLoopList(20), CurveLoopList(21), CurveLoopList(22), CurveLoopList(23), CurveLoopList(24), CurveLoopList(25), CurveLoopList(26), CurveLoopList(27), CurveLoopList(28), CurveLoopList(29), CurveLoopList(30), CurveLoopList(31), CurveLoopList(32), CurveLoopList(33), CurveLoopList(34), CurveLoopList(35), CurveLoopList(36), CurveLoopList(37), CurveLoopList(38), CurveLoopList(39), CurveLoopList(40), CurveLoopList(41), CurveLoopList(42), CurveLoopList(43), CurveLoopList(44), CurveLoopList(45), CurveLoopList(46), CurveLoopList(47), CurveLoopList(48), CurveLoopList(49), CurveLoopList(50), CurveLoopList(51), CurveLoopList(52), CurveLoopList(53), CurveLoopList(54), CurveLoopList(55), CurveLoopList(56), CurveLoopList(57), CurveLoopList(58), CurveLoopList(59), CurveLoopList(60), CurveLoopList(61), CurveLoopList(62), CurveLoopList(63), CurveLoopList(64), CurveLoopList(65), CurveLoopList(66), CurveLoopList(67), CurveLoopList(68), CurveLoopList(69), CurveLoopList(70), CurveLoopList(71), CurveLoopList(72), CurveLoopList(73), CurveLoopList(74), CurveLoopList(75), CurveLoopList(76), CurveLoopList(77), CurveLoopList(78), CurveLoopList(79), CurveLoopList(80), CurveLoopList(81), CurveLoopList(82), CurveLoopList(83), CurveLoopList(84), CurveLoopList(85), CurveLoopList(86), CurveLoopList(87), CurveLoopList(88), CurveLoopList(89), CurveLoopList(90), CurveLoopList(91), CurveLoopList(92), CurveLoopList(93), CurveLoopList(94), CurveLoopList(95), CurveLoopList(96), CurveLoopList(97), CurveLoopList(98), CurveLoopList(99), CurveLoopList(100), CurveLoopList(101), CurveLoopList(102), CurveLoopList(103), CurveLoopList(104), CurveLoopList(105), CurveLoopList(106), CurveLoopList(107), CurveLoopList(108), CurveLoopList(109), CurveLoopList(110), CurveLoopList(111), CurveLoopList(112), CurveLoopList(113), CurveLoopList(114), CurveLoopList(115), CurveLoopList(116), CurveLoopList(117), CurveLoopList(118), CurveLoopList(119), CurveLoopList(120), CurveLoopList(121), CurveLoopList(122), CurveLoopList(123), CurveLoopList(124), CurveLoopList(125), CurveLoopList(126), CurveLoopList(127), CurveLoopList(128), CurveLoopList(129), CurveLoopList(130), CurveLoopList(131), CurveLoopList(132), CurveLoopList(133), CurveLoopList(134), CurveLoopList(135), CurveLoopList(136), CurveLoopList(137), CurveLoopList(138), CurveLoopList(139), CurveLoopList(140), CurveLoopList(141), CurveLoopList(142), CurveLoopList(143), CurveLoopList(144), CurveLoopList(145), CurveLoopList(146), CurveLoopList(147), CurveLoopList(148), CurveLoopList(149), CurveLoopList(150), CurveLoopList(151), CurveLoopList(152), CurveLoopList(153), CurveLoopList(154), CurveLoopList(155), CurveLoopList(156), CurveLoopList(157), CurveLoopList(158), CurveLoopList(159), CurveLoopList(160), CurveLoopList(161), CurveLoopList(162), CurveLoopList(163), CurveLoopList(164), CurveLoopList(165), CurveLoopList(166), CurveLoopList(167), CurveLoopList(168), CurveLoopList(169), CurveLoopList(170), CurveLoopList(171), CurveLoopList(172), CurveLoopList(173), CurveLoopList(174), CurveLoopList(175), CurveLoopList(176), CurveLoopList(177), CurveLoopList(178), CurveLoopList(179), CurveLoopList(180), CurveLoopList(181), CurveLoopList(182), CurveLoopList(183), CurveLoopList(184), CurveLoopList(185), CurveLoopList(186), CurveLoopList(187), CurveLoopList(188), CurveLoopList(189), CurveLoopList(190), CurveLoopList(191), CurveLoopList(192), CurveLoopList(193), CurveLoopList(194), CurveLoopList(195), CurveLoopList(196), CurveLoopList(197), CurveLoopList(198), CurveLoopList(199), CurveLoopList(200), CurveLoopList(201), CurveLoopList(202), CurveLoopList(203), CurveLoopList(204), CurveLoopList(205), CurveLoopList(206), CurveLoopList(207), CurveLoopList(208), CurveLoopList(209), CurveLoopList(210), CurveLoopList(211), CurveLoopList(212), CurveLoopList(213), CurveLoopList(214), CurveLoopList(215), CurveLoopList(216), CurveLoopList(217), CurveLoopList(218), CurveLoopList(219), CurveLoopList(220), CurveLoopList(221), CurveLoopList(222), CurveLoopList(223), CurveLoopList(224), CurveLoopList(225), CurveLoopList(226), CurveLoopList(227), CurveLoopList(228), CurveLoopList(229), CurveLoopList(230), CurveLoopList(231), CurveLoopList(232), CurveLoopList(233), CurveLoopList(234), CurveLoopList(235), CurveLoopList(236), CurveLoopList(237), CurveLoopList(238), CurveLoopList(239), CurveLoopList(240), CurveLoopList(241), CurveLoopList(242), CurveLoopList(243), CurveLoopList(244), CurveLoopList(245), CurveLoopList(246), CurveLoopList(247), CurveLoopList(248), CurveLoopList(249), CurveLoopList(250), CurveLoopList(251), CurveLoopList(252), CurveLoopList(253), CurveLoopList(254), CurveLoopList(255), CurveLoopList(256), CurveLoopList(257), CurveLoopList(258), CurveLoopList(259), CurveLoopList(260), CurveLoopList(261), CurveLoopList(262), CurveLoopList(263), CurveLoopList(264), CurveLoopList(265), CurveLoopList(266), CurveLoopList(267), CurveLoopList(268), CurveLoopList(269), CurveLoopList(270), CurveLoopList(271), CurveLoopList(272), CurveLoopList(273), CurveLoopList(274), CurveLoopList(275), CurveLoopList(276), CurveLoopList(277), CurveLoopList(278), CurveLoopList(279), CurveLoopList(280), CurveLoopList(281), CurveLoopList(282), CurveLoopList(283), CurveLoopList(284), CurveLoopList(285), CurveLoopList(286), CurveLoopList(287), CurveLoopList(288), CurveLoopList(289), CurveLoopList(290), CurveLoopList(291), CurveLoopList(292), CurveLoopList(293), CurveLoopList(294), CurveLoopList(295), CurveLoopList(296), CurveLoopList(297), CurveLoopList(298), CurveLoopList(299), CurveLoopList(300), CurveLoopList(301), CurveLoopList(302), CurveLoopList(303), CurveLoopList(304), CurveLoopList(305), CurveLoopList(306), CurveLoopList(307), CurveLoopList(308), CurveLoopList(309), CurveLoopList(310), CurveLoopList(311), CurveLoopList(312), CurveLoopList(313), CurveLoopList(314), CurveLoopList(315), CurveLoopList(316), CurveLoopList(317), CurveLoopList(318), CurveLoopList(319), CurveLoopList(320), CurveLoopList(321), CurveLoopList(322), CurveLoopList(323), CurveLoopList(324), CurveLoopList(325), CurveLoopList(326), CurveLoopList(327), CurveLoopList(328), CurveLoopList(329), CurveLoopList(330), CurveLoopList(331), CurveLoopList(332), CurveLoopList(333), CurveLoopList(334), CurveLoopList(335), CurveLoopList(336), CurveLoopList(337), CurveLoopList(338), CurveLoopList(339), CurveLoopList(340), CurveLoopList(341), CurveLoopList(342), CurveLoopList(343), CurveLoopList(344), CurveLoopList(345), CurveLoopList(346), CurveLoopList(347), CurveLoopList(348), CurveLoopList(349), CurveLoopList(350), CurveLoopList(351), CurveLoopList(352), CurveLoopList(353), CurveLoopList(354), CurveLoopList(355)};

Plane Surface(1) = {(b0+1)};


For i In {1:b0}
	Plane Surface(i+1) = {i};
EndFor

BooleanDifference(b0+2) = {Surface{1}; Delete;}{Surface{2:(b0+1)}; Delete;};

// Diagnostic
//Printf("SurfaceID = '%g'",(b0+2));

Mesh.Algorithm = 5;
