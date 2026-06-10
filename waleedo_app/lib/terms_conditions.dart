import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'Design System/Buttons/primary_button.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButton = true;

  Widget header(String text,{TextStyle style = fonts.lb ,Color color = color.g400 } ) {
    return Text(text,style: style.copyWith(color: color),);
  }

  Widget text(String text,{TextStyle style = fonts.sr, Color color = color.g400}) {
    return Text(text,style: style.copyWith(color: color),);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final bool atBottom = position.pixels >= (position.maxScrollExtent - 20);

    if (atBottom != !_showScrollButton) {
      setState(() {
        _showScrollButton = !atBottom;
      });
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "الشروط والاحكام",
        centerTheTitles: true,
        showAction: false,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: header(
                          "الشروط والأحكام",
                          style: fonts.h6,
                          color: color.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      text(
                        "اخر تحديث: امس",
                        style: fonts.ss,
                        color: color.g300,
                      ),
                      const SizedBox(height: 8),

                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                'مرحبًا بك في متجر M4_STORE. باستخدامك لهذا الموقع أو التطبيق أو أي من الخدمات المرتبطة به، فإنك توافق على الالتزام بهذه الشروط والأحكام. '
                                'يرجى قراءة هذه الصفحة بعناية قبل إتمام أي عملية شراء أو تسجيل حساب أو استخدام أي من خدمات المتجر. '
                                'في حال عدم موافقتك على أي بند من هذه البنود، نرجو منك عدم استخدام المنصة.',
                              ),
                              const SizedBox(height: 12),

                              header('1) التعريف بالخدمة'),
                              const SizedBox(height: 2),
                              text(
                                'M4_STORE هو متجر إلكتروني يقدّم منتجات وخدمات مرتبطة بالمجال العسكري أو الملحقات ذات الصلة، '
                                'ويعمل وفق الأنظمة واللوائح المعمول بها. جميع المنتجات المعروضة على المتجر تخضع للتوفر، وقد يتم تعديلها أو إيقافها أو تحديثها في أي وقت دون إشعار مسبق.',
                              ),
                              const SizedBox(height: 12),

                              header('2) الأهلية القانونية'),
                              const SizedBox(height: 2),
                              text(
                                'لا يحق استخدام هذا المتجر أو إنشاء حساب أو إتمام عمليات شراء إلا للأشخاص الذين لديهم الأهلية القانونية الكاملة وفقًا لقوانين بلدهم. '
                                'ويتحمل المستخدم وحده مسؤولية التأكد من أن استخدامه للمتجر وعمليات الشراء التي يقوم بها متوافقة مع القوانين المحلية والأنظمة التنظيمية السارية.',
                              ),
                              const SizedBox(height: 12),

                              header('3) الالتزام بالقوانين والأنظمة'),
                              const SizedBox(height: 2),
                              text(
                                'يوافق المستخدم على أن جميع الطلبات والمشتريات والاستخدامات المرتبطة بالمتجر يجب أن تكون قانونية ومشروعة. '
                                'ويُمنع استخدام أي منتج أو خدمة بطريقة مخالفة للقانون، أو لغرض غير مشروع، أو بما يهدد سلامة الآخرين أو أمنهم. '
                                'كما يحتفظ المتجر بحقه في رفض أو إلغاء أي طلب يشتبه في مخالفته للأنظمة أو التعليمات أو الشروط الداخلية.',
                              ),
                              const SizedBox(height: 12),

                              header('4) الحسابات والمسؤولية'),
                              const SizedBox(height: 2),
                              text(
                                'عند إنشاء حساب في M4_STORE، يتوجب على المستخدم تقديم معلومات صحيحة وكاملة وحديثة. '
                                'ويتحمل المستخدم مسؤولية الحفاظ على سرية بيانات الدخول الخاصة به، ويكون مسؤولًا عن جميع الأنشطة التي تتم من خلال حسابه. '
                                'يجب عليه إبلاغ إدارة المتجر فورًا في حال الاشتباه بأي استخدام غير مصرح به للحساب.',
                              ),
                              const SizedBox(height: 12),

                              header('5) دقة المعلومات'),
                              const SizedBox(height: 2),
                              text(
                                'نسعى إلى عرض معلومات دقيقة وواضحة حول المنتجات والأسعار والمواصفات والصور، إلا أنه قد تظهر بعض الأخطاء غير المقصودة. '
                                'لذلك يحتفظ المتجر بحق تصحيح أي خطأ في الوصف أو السعر أو التوفر في أي وقت، حتى بعد تقديم الطلب، '
                                'مع إبلاغ العميل في حال كان ذلك ضروريًا. الصور المعروضة لأغراض التوضيح وقد تختلف أحيانًا عن المنتج الفعلي من حيث الشكل أو الملحقات.',
                              ),
                              const SizedBox(height: 12),

                              header('6) الأسعار والدفع'),
                              const SizedBox(height: 2),
                              text(
                                'جميع الأسعار المعروضة داخل المتجر قابلة للتغيير في أي وقت دون إشعار مسبق، ما لم يتم تأكيد الطلب بشكل نهائي. '
                                'تتم معالجة عمليات الدفع عبر الوسائل المتاحة في المتجر، ويوافق المستخدم على تزويدنا ببيانات دفع صحيحة ومصرح بها. '
                                'وفي حال فشل عملية الدفع أو وجود مشكلة في التحصيل، يحق للمتجر تعليق الطلب أو إلغاؤه حتى يتم استكمال الإجراءات المطلوبة.',
                              ),
                              const SizedBox(height: 12),

                              header('7) تأكيد الطلب'),
                              const SizedBox(height: 2),
                              text(
                                'إرسال الطلب لا يعني قبوله بشكل نهائي، بل يخضع لمراجعة المتجر والتأكد من التوفر وصحة البيانات واستيفاء الشروط. '
                                'قد يتم التواصل مع العميل لتأكيد بعض التفاصيل قبل الشحن أو التسليم. '
                                'ويحق للمتجر إلغاء أي طلب في حال وجود نقص في البيانات أو عدم الالتزام بالشروط أو الاشتباه في أي نشاط غير نظامي.',
                              ),
                              const SizedBox(height: 12),

                              header('8) الشحن والتسليم'),
                              const SizedBox(height: 2),
                              text(
                                'تتم عمليات الشحن والتسليم وفقًا للسياسة المعتمدة داخل المتجر وبحسب المنطقة الجغرافية وقابلية التوصيل. '
                                'قد تختلف مدة التوصيل حسب المكان، وتوفّر المنتج، والإجراءات الداخلية، وظروف النقل. '
                                'ويتحمل العميل مسؤولية إدخال بيانات الشحن بدقة، بما في ذلك الاسم والعنوان ورقم الهاتف. '
                                'أي تأخير ناتج عن إدخال بيانات خاطئة أو غير مكتملة لا تتحمل مسؤوليته إدارة المتجر.',
                              ),
                              const SizedBox(height: 12),

                              header('9) الاستلام والفحص'),
                              const SizedBox(height: 2),
                              text(
                                'يلتزم العميل بفحص الطلب عند الاستلام والتأكد من مطابقته لما تم طلبه. '
                                'وفي حال وجود نقص أو تلف ظاهر أو اختلاف واضح، يجب التواصل مع خدمة العملاء خلال المدة المحددة في سياسة المتجر. '
                                'أما بعد استلام الطلب والتوقيع أو التأكيد على التسليم، فقد يصبح من الصعب اعتماد أي مطالبة لاحقة إذا لم يتم الإبلاغ في الوقت المناسب.',
                              ),
                              const SizedBox(height: 12),

                              header('10) الإرجاع والاستبدال'),
                              const SizedBox(height: 2),
                              text(
                                'تخضع طلبات الإرجاع أو الاستبدال لشروط محددة يحددها المتجر. '
                                'قد لا تكون بعض المنتجات قابلة للإرجاع أو الاستبدال بسبب طبيعتها أو حالتها أو كونها مخصصة حسب الطلب. '
                                'ويجب أن يكون المنتج في حالته الأصلية وغير مستخدم، مع الحفاظ على جميع الملحقات والتغليف والفواتير، ما لم تنص سياسة المتجر على غير ذلك.',
                              ),
                              const SizedBox(height: 12),

                              header('11) الإلغاء'),
                              const SizedBox(height: 2),
                              text(
                                'يمكن إلغاء الطلب قبل تأكيده أو قبل بدء التجهيز بحسب ما تسمح به أنظمة المتجر. '
                                'أما الطلبات التي دخلت مرحلة التحضير أو الشحن فقد لا يمكن إلغاؤها إلا وفق شروط خاصة. '
                                'ويحق للمتجر إلغاء الطلب من طرفه إذا تطلب الأمر ذلك بسبب خطأ تقني أو نقص في المخزون أو أي سبب تنظيمي أو أمني.',
                              ),
                              const SizedBox(height: 12),

                              header('12) الاستخدام المسؤول'),
                              const SizedBox(height: 2),
                              text(
                                'يتحمل المستخدم كامل المسؤولية عن استخدام أي منتج يشتريه من المتجر استخدامًا مشروعًا وآمنًا ومسؤولًا. '
                                'ويتعهد بعدم إساءة الاستخدام أو نقل المنتج أو التعامل معه بطريقة تخالف القانون أو تهدد السلامة العامة. '
                                'كما يوافق على أن أي استخدام غير قانوني أو غير مسؤول يقع تحت مسؤوليته الشخصية الكاملة.',
                              ),
                              const SizedBox(height: 12),

                              header('13) السلامة العامة'),
                              const SizedBox(height: 2),
                              text(
                                'يجب على المستخدم الالتزام بجميع إرشادات السلامة والتخزين والنقل والاستخدام التي يحددها المصنع أو الجهة المختصة أو القوانين المحلية. '
                                'ولا يتحمل المتجر مسؤولية أي ضرر ناتج عن سوء الاستخدام أو الإهمال أو التخزين غير السليم أو العبث أو الاستخدام غير المصرح به. '
                                'كما ننصح المستخدم دائمًا باتباع التعليمات الرسمية والرجوع إلى الجهات المختصة عند الحاجة.',
                              ),
                              const SizedBox(height: 12),

                              header('14) الملكية الفكرية'),
                              const SizedBox(height: 2),
                              text(
                                'جميع المحتويات المنشورة على المتجر، بما في ذلك النصوص والصور والشعارات والتصميمات والرموز والواجهات، '
                                'هي ملك لمتجر M4_STORE أو مستخدمة بإذن قانوني. '
                                'ولا يجوز نسخها أو إعادة نشرها أو استخدامها في أي موقع أو منصة أخرى دون موافقة خطية مسبقة.',
                              ),
                              const SizedBox(height: 12),

                              header('15) المحتوى المقدم من المستخدم'),
                              const SizedBox(height: 2),
                              text(
                                'إذا أتاح المتجر للمستخدمين كتابة مراجعات أو تقييمات أو تعليقات، فيجب أن تكون هذه المحتويات محترمة وصادقة وغير مخالفة للقانون. '
                                'يحق للمتجر حذف أو تعديل أو إخفاء أي محتوى مسيء أو مضلل أو مخالف أو غير مناسب دون إشعار مسبق.',
                              ),
                              const SizedBox(height: 12),

                              header('16) الخصوصية وحماية البيانات'),
                              const SizedBox(height: 2),
                              text(
                                'تتم معالجة بيانات المستخدم وفق سياسة الخصوصية الخاصة بالمتجر. '
                                'ونلتزم بحماية البيانات الشخصية وعدم مشاركتها إلا عند الحاجة التشغيلية أو القانونية أو عند الضرورة لتقديم الخدمة. '
                                'باستخدامك للمتجر، فإنك توافق على جمع واستخدام بعض البيانات بما يخدم تنفيذ الطلبات وتحسين الخدمة.',
                              ),
                              const SizedBox(height: 12),

                              header('17) تعليق أو إيقاف الحساب'),
                              const SizedBox(height: 2),
                              text(
                                'يحق للمتجر تعليق أو إيقاف أو حذف أي حساب في حال وجود مخالفة للشروط والأحكام أو إساءة استخدام أو نشاط مريب أو طلب رسمي من جهة مختصة. '
                                'ولا يحق للمستخدم المطالبة بأي تعويض إذا تم اتخاذ هذا الإجراء بسبب مخالفة واضحة أو استخدام غير مشروع.',
                              ),
                              const SizedBox(height: 12),

                              header('18) حدود المسؤولية'),
                              const SizedBox(height: 2),
                              text(
                                'يبذل المتجر جهده لتقديم الخدمة بأعلى جودة ممكنة، لكنه لا يضمن خلو الخدمة من الانقطاع أو الأخطاء التقنية أو تأخر التحديثات. '
                                'ولا يتحمل المتجر المسؤولية عن أي خسائر غير مباشرة أو أضرار ناتجة عن سوء استخدام المنصة أو أخطاء المستخدم أو ظروف خارجة عن الإرادة.',
                              ),
                              const SizedBox(height: 12),

                              header('19) التعديلات على الشروط'),
                              const SizedBox(height: 2),
                              text(
                                'يحتفظ M4_STORE بحقه في تعديل أو تحديث هذه الشروط والأحكام في أي وقت دون إشعار مسبق. '
                                'وتصبح التعديلات نافذة فور نشرها داخل المتجر. '
                                'وعلى المستخدم مراجعة هذه الصفحة بشكل دوري للتأكد من اطلاعه على آخر التحديثات.',
                              ),
                              const SizedBox(height: 12),

                              header('20) القانون الواجب التطبيق'),
                              const SizedBox(height: 2),
                              text(
                                'تُفسَّر هذه الشروط والأحكام وتُطبَّق وفقًا للقوانين والأنظمة المعمول بها في البلد الذي يعمل فيه المتجر، '
                                'وفي حال وجود أي نزاع، تتم معالجته عبر القنوات القانونية المختصة.',
                              ),
                              const SizedBox(height: 12),

                              header('21) التواصل معنا'),
                              const SizedBox(height: 2),
                              text(
                                'للاستفسارات أو الشكاوى أو طلبات الدعم، يمكنكم التواصل مع فريق M4_STORE عبر وسائل الاتصال المتاحة داخل التطبيق أو الموقع. '
                                'ونحن نسعى دائمًا للرد على الطلبات في أقرب وقت ممكن وتقديم المساعدة اللازمة.',
                              ),
                              const SizedBox(height: 30),

                              p_button(
                                title: "اغلاق",
                                height: 40,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                             
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (_showScrollButton)
              Positioned(
                left: 10,
                bottom: 15,
                child: Container(
                  decoration: BoxDecoration(
                    color: color.p500,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_double_arrow_down),
                    color: color.white,
                    iconSize: 28,
                    onPressed: _scrollToBottom,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}