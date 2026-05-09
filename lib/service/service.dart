import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:site720_client/model/ComplaintListsModel.dart';
import 'package:site720_client/model/aboutUsModel.dart';
import 'package:site720_client/model/addComplaintModel.dart';
import 'package:site720_client/model/apiResponseModel.dart';
import 'package:site720_client/model/changePasswordModel.dart';
import 'package:site720_client/model/client_details/client_by_id.dart';
import 'package:site720_client/model/client_details/deduction_work_model.dart';
import 'package:site720_client/model/client_details/drawings_model.dart';
import 'package:site720_client/model/client_details/extra_work.dart';
import 'package:site720_client/model/client_details/schedule_payment_model.dart';
import 'package:site720_client/model/client_details/stage_list_model.dart';
import 'package:site720_client/model/client_details/work_updation_model.dart';
import 'package:site720_client/model/client_details/gallery.dart';
import 'package:site720_client/model/client_details/get_icons.dart';
import 'package:site720_client/model/client_details/payment_list.dart';
import 'package:site720_client/model/client_details/phase_video_model.dart';
import 'package:site720_client/model/complaintDetailsModel.dart';
import 'package:site720_client/model/complaintListModel.dart';
import 'package:site720_client/model/complaintNatureModel.dart';
import 'package:site720_client/model/complaintReportedByModel.dart';
import 'package:site720_client/model/complaintTypeModel.dart';
import 'package:site720_client/model/contactUsModel.dart';
import 'package:site720_client/model/emiListModel.dart';
import 'package:site720_client/model/forceUpdateModel.dart';
import 'package:site720_client/model/getDocDetailsModel.dart';
import 'package:site720_client/model/getPercentageModel.dart';
import 'package:site720_client/model/homePageModel.dart';
import 'package:site720_client/model/labourCountModel.dart';
import 'package:site720_client/model/loginModel.dart';
import 'package:site720_client/model/phoneNumberCheck.dart';
import 'package:site720_client/model/profilePageModel.dart';
import 'package:site720_client/model/projectDetailsModel.dart';
import 'package:site720_client/model/projectListModel.dart';
import 'package:site720_client/model/resetPasswordModel.dart';
import 'package:site720_client/model/sendOtpModel.dart';
import 'package:site720_client/model/serviceListModel.dart';
import 'package:site720_client/settings/config.dart';

import '../model/bhkFilterListModel.dart';
import '../model/client_details/extrawork_dates_model.dart';
import '../model/quotationEnquiryModel.dart';
import '../model/villaProjectModel.dart';
import '../model/workDateModel.dart';

class HttpService {
  static final Dio _dio = Dio();
  static Future forceUpdate() async {
    try {
      var result = await _dio.get("${Config.apiBaseUrl}force_updation_data");
      ForceUpdateModel model = ForceUpdateModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future login(userPin, phone, password, deviceToken) async {
    var formData = FormData.fromMap({
      'userPin': userPin,
      'phone': phone,
      'password': password,
      'deviceToken': deviceToken,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}login", data: formData);
      if (result.statusCode == 200) {
        LoginModel model = LoginModel.fromJson(result.data);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future changePassword(token, password) async {
    var formData = FormData.fromMap({
      'token': token,
      'password': password,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}resetPassword", data: formData);
      ChangePasswordModel model = ChangePasswordModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addContactForm(
      name, phoneNumber, place, serviceId, message) async {
    var formData = FormData.fromMap({
      'name': name,
      'phone': phoneNumber,
      'place': place,
      'service_id': serviceId,
      'message': message,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}add_contact_form",
          data: formData);
      //log(params);

      ContactUsModel model = ContactUsModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future addQuotationForm(
      name, phoneNumber, planImage, dImage, message) async {
    var formData = FormData.fromMap({
      'name': name,
      'phone_number': phoneNumber,
      'plan_image': await MultipartFile.fromFile(planImage!),
      '3d_plan':
          dImage == null ? dImage : await MultipartFile.fromFile(dImage!),
      'message': message,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}postEnquiry", data: formData);
      //log(params);

      QuotationEnquiryModel model = QuotationEnquiryModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientByID(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}getClientByID", data: formData);

      ClientByIdModel model = ClientByIdModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getGallery(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientPhasesImages",
          data: formData);
      //log(params);

      GalleryModel model = GalleryModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientPaymentDetails(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio
          .post("${Config.apiBaseUrl}getClientPaymentDetails", data: formData);
      //log(params);

      if (result.statusCode == 200) {
        PaymentListModel model = PaymentListModel.fromJson(result.data);
        return model;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future getClientScheduledPayment(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(
          "${Config.apiBaseUrl}getClientScheduledPayment",
          data: formData);
      //log(params);

      SchedulePaymentModel model = SchedulePaymentModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getStageList(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientStages",
          data: formData);

      if (result.statusCode == 200) {
        StageListModel model = StageListModel.fromJson(result.data);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientDeductionWork(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientDeductionWork",
          data: formData);
      if (result.statusCode == 200) {
        DeductionWorkModel model = DeductionWorkModel.fromJson(result.data);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientPhasesVideo(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientPhasesVideo",
          data: formData);
      //log(params);

      PhaseVideoModel model = PhaseVideoModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getWorkStatus(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientWorkUpdates",
          data: formData);
      //log(params);

      ClientWorkStatusModel model = ClientWorkStatusModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<WorkDatesModel?> getWorkDates(
      String token, int year, int month) async {
    var formData = FormData.fromMap({
      'token': token,
      'year': year,
      'month': month,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}getWorkedDays", data: formData);
      if (result.statusCode == 200) {
        return workDatesModelFromJson(result.data);
      } else {
        throw Exception('Failed to load work dates');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<ExtraworkDates?> getClientExtraWorkForDate(
    String token,
    DateTime selectedDate,
  ) async {
    var formData = FormData.fromMap({
      'token': token,
      'selected_date': selectedDate,
    });

    try {
      var result = await _dio.post(
        "${Config.apiBaseUrl}getExtraWorkForDate",
        data: formData,
      );
      if (result.statusCode == 200) {
        return ExtraworkDates.fromJson(result.data);
      } else {
        throw Exception('Failed to load extra work data');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future getClientExtraWork(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientExtraWork",
          data: formData);
      ExtraWorkModel model = ExtraWorkModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientPackage(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post(
        "${Config.apiBaseUrl}getClientPackage",
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );
      //

      // PackageModel model = PackageModel.fromJson(result.data);

      return result;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future profile(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientDetails",
          data: formData);
      //log(params);

      ProfilePageModel model = ProfilePageModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getClientSiteDrawings(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}getClientSiteDrawings",
          data: formData);
      //log(params);

      DrawingsModel model = DrawingsModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getIcons(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}getIcons", data: formData);
      //log(params);

      GetIconsModel model = GetIconsModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future complaintList(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}view_complaint", data: formData);
      //log(params);

      ComplaintListModel model = ComplaintListModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<AddComplaintModel?> addComplaint({
    required String token,
    required String complaintType,
    required String reportedBy,
    required String incidentDate,
    required String description,
    required String nature,
    File? image,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "token": token,
        "complaint_type": complaintType,
        "reported_by": reportedBy,
        "incident_date": incidentDate,
        "description": description,
        "nature": nature,
        if (image != null)
          "image": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      final response = await _dio.post(
        "${Config.apiBaseUrl}add_complaint",
        data: formData,
      );

      if (response.statusCode == 200) {
        return AddComplaintModel.fromJson(response.data);
      } else {
        throw Exception("Failed to add complaint");
      }
    } catch (e, st) {
      log("Add Complaint Error: $e\n$st");
      return null;
    }
  }

  // static Future<HomePageModel?> dashboard(String token) async {
  //   print("Dashboard token: $token");
  //   try {
  //     var result = await _dio.get(
  //       "${Config.apiBaseUrl}home",
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer $token",
  //         },
  //       ),
  //     );

  //     return HomePageModel.fromJson(result.data);
  //   } catch (e) {
  //     log("Dashboard error: $e");
  //     return null;
  //   }
  // }

  // static Future<HomePageModel?> dashboard(String token) async {
  //   print("Dashboard token: $token");
  //   try {
  //     var result = await _dio.post(
  //       "${Config.apiBaseUrl}home",
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer $token",
  //         },
  //       ),
  //       data: {
  //         "token": token,
  //       },
  //     );
  //     return HomePageModel.fromJson(result.data);
  //   } catch (e) {
  //     log("Dashboard error: $e");
  //     return null;
  //   }
  // }

  static Future<HomePageModel?> dashboard(String token) async {
    print("Dashboard token: $token");
    try {
      FormData formData = FormData.fromMap({
        "token": token,
      });
      var result = await _dio.post(
        "${Config.apiBaseUrl}home",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      return HomePageModel.fromJson(result.data);
    } catch (e) {
      log("Dashboard error: $e");
      return null;
    }
  }

  static Future projectList(
    currentPage,
    itemPerPage,
    bhk,
    minAmount,
    maxAmount,
    minSquareFeet,
    maxSquareFeet,
    token,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        "currentPage": currentPage,
        "itemPerPage": itemPerPage,
        "bhk": bhk,
        "minAmount": minAmount,
        "maxAmount": maxAmount,
        "minSquareFeet": minSquareFeet,
        "maxSquareFeet": maxSquareFeet,
        "token": token,
      });

      var result = await _dio.post(
        "${Config.apiBaseUrl}newdashboard",
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      return ProjectListModel.fromJson(result.data);
    } catch (e) {
      log("ProjectList Error => $e");
      return null;
    }
  }

  static Future projectDetails(projectId) async {
    var formData = FormData.fromMap({
      'project_id': projectId,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}projectDetails", data: formData);

      ProjectDetailsModel model = ProjectDetailsModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future aboutUs() async {
    try {
      var result = await _dio.get("${Config.apiBaseUrl}about_us");

      AboutUsModel model = AboutUsModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future serviceList() async {
    log('a');
    try {
      var result = await _dio.get("${Config.apiBaseUrl}serviceList");

      ServiceListModel model = ServiceListModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future phoneNumberCheck(phoneNumber) async {
    var formData = FormData.fromMap({
      'phone': phoneNumber,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}check_phone_number",
          data: formData);

      PhoneNumberCheck model = PhoneNumberCheck.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future sendOtp(phoneNumber, otp) async {
    var formData = FormData.fromMap({
      'phone': phoneNumber,
      'otp': otp,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}sendOTP", data: formData);

      SendOtpModel model = SendOtpModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future resetPassword(phoneNumber, password) async {
    var formData = FormData.fromMap({
      'phone': phoneNumber,
      'password': password,
    });
    try {
      var result =
          await _dio.post("${Config.apiBaseUrl}reset_password", data: formData);

      ResetPasswordModel model = ResetPasswordModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future bhkFilterList() async {
    try {
      var result = await _dio.get("${Config.apiBaseUrl}getCategory");

      BhkFilterListModel model = BhkFilterListModel.fromJson(result.data);
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  // static Future villaProjectList() async {
  //   try {
  //     var result = await _dio.get("${Config.apiBaseUrl}villaProjects");

  //     VillaProjectModel model = VillaProjectModel.fromJson(result.data);
  //     return model;
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }
  static Future<VillaProjectModel?> villaProjectList(
      {required String token}) async {
    try {
      FormData formData = FormData.fromMap({
        "token": token,
      });
      var response = await _dio.post(
        "${Config.apiBaseUrl}villaProjects",
        data: formData,
      );
      if (response.statusCode == 200) {
        return VillaProjectModel.fromJson(response.data);
      }
    } catch (e) {
      log("villaProjectList error: $e");
    }

    return null;
  }

  static Future getComplaintType(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}get_complaint_type",
          data: formData);
      //log(params);

      ComplaintTypeModel model = ComplaintTypeModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getComplaintReportedBy(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio
          .post("${Config.apiBaseUrl}get_complaint_reportedby", data: formData);
      //log(params);

      ComplaintReportedByModel model =
          ComplaintReportedByModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getComplaintNature(token) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}get_complaint_nature",
          data: formData);
      //log(params);

      ComplaintNatureModel model = ComplaintNatureModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<ComplaintListResponse?> getComplaintList(String token) async {
    try {
      FormData formData = FormData.fromMap({
        'token': token,
      });

      var response = await _dio.post(
        "${Config.apiBaseUrl}get_complaint_list",
        data: formData,
      );

      ComplaintListResponse model =
          ComplaintListResponse.fromJson(response.data);

      return model;
    } catch (e) {
      log("getComplaintList Error: ${e.toString()}");
      return null;
    }
  }

  static Future<bool> deleteComplaint(String token, String id) async {
    try {
      FormData data = FormData.fromMap({
        "token": token,
        "id": id,
      });

      await _dio.post("${Config.apiBaseUrl}deleteComplaint", data: data);

      return true;
    } catch (e) {
      log("Delete error: $e");
      return false;
    }
  }

  static Future<ComplaintDetailResponse> getComplaintById(
    String token,
    int id,
  ) async {
    try {
      FormData data = FormData.fromMap({
        "token": token,
        "id": id.toString(),
      });

      final response = await _dio.post(
        "${Config.apiBaseUrl}getComplaintById", // update endpoint if needed
        data: data,
      );

      if (response.statusCode == 200) {
        return ComplaintDetailResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch complaint details");
      }
    } catch (e, st) {
      log("Get complaint error: $e\n$st");
      rethrow;
    }
  }

  static Future<ApiResponse?> updateComplaint({
    required String token,
    required int complaintId,
    required String complaintType,
    required String reportedBy,
    required String incidentDate,
    required String description,
    required String nature,
    File? image,
  }) async {
    try {
      FormData data = FormData.fromMap({
        "token": token,
        "complaint_id": complaintId.toString(),
        "complaint_type": complaintType,
        "reported_by": reportedBy,
        "incident_date": incidentDate,
        "description": description,
        "nature": nature,
        if (image != null)
          "image": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      final response = await _dio.post(
        "${Config.apiBaseUrl}updateComplaint",
        data: data,
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to update complaint");
      }
    } catch (e, st) {
      log("Update complaint error: $e\n$st");
      return null;
    }
  }

  static Future<EmiListResponse?> getEmiList(
      {String? token, required String projectId}) async {
    try {
      FormData formData = FormData.fromMap({
        "token": token ?? "",
        "projectId": projectId,
      });

      final response = await _dio.post(
        "${Config.apiBaseUrl}getEmiLists",
        data: formData,
      );

      if (response.statusCode == 200) {
        EmiListResponse model = EmiListResponse.fromJson(response.data);
        return model;
      } else {
        log("getEmiList failed: ${response.statusCode}");
        return null;
      }
    } catch (e, st) {
      log("getEmiList Error: $e\n$st");
      return null;
    }
  }

  static Future getDocsData(token, projectId) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
      'projectId': projectId,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}get_project_documents",
          data: formData);
      //log(params);

      GetDocsDetails model = GetDocsDetails.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getGraphData(token, projectId) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
      'projectId': projectId,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}get_stage_percent",
          data: formData);
      //log(params);

      GetPercentModel model = GetPercentModel.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future getCountData(token, projectId) async {
    log(token);
    var formData = FormData.fromMap({
      'token': token,
      'projectId': projectId,
    });
    try {
      var result = await _dio.post("${Config.apiBaseUrl}get_labours_count",
          data: formData);
      GetCountLabours model = GetCountLabours.fromJson(result.data);

      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<Map<String, dynamic>> verifyPin(String pin) async {
    try {
      FormData formData = FormData.fromMap({
        "pin": pin,
      });

      final response = await _dio.post(
        "${Config.apiBaseUrl}verify_pin",
        data: formData,
      );

      if (response.statusCode == 200) {
        return {
          'success': response.data['status'] == true,
          'message': response.data['message'] ?? '',
          'data': response.data['data'] ?? [],
        };
      } else {
        log("PIN verification failed: ${response.statusCode}");
        return {
          'success': false,
          'message': 'Verification failed',
          'data': [],
        };
      }
    } catch (e, st) {
      log("PIN verification Error: $e\n$st");
      return {
        'success': false,
        'message': 'Network error',
        'data': [],
      };
    }
  }
}
